resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = local.resource_name
  }
}

locals {
  tailscale_config = {
    oauth = {
      clientId = local.oauth_client_id
    }

    operatorConfig = {
      hostname    = "${local.stack_name}-${local.env_name}-k8s-operator"
      defaultTags = ["tag:k8s-operator"]
    }

    proxyConfig = {
      defaultTags = "tag:${local.stack_name}-${local.env_name}"
    }
  }
}

resource "helm_release" "tailscale" {
  name             = "tailscale-operator"
  create_namespace = false
  namespace        = kubernetes_namespace.tailscale.metadata[0].name
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  wait             = true

  values = [
    yamlencode(local.tailscale_config)
  ]

  set_sensitive = [
    {
      name  = "oauth.clientSecret"
      value = local.oauth_client_secret
    }
  ]
}
