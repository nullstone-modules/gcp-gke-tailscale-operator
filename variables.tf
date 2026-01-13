variable "oauth_client_id" {
  type        = string
  description = <<EOF
Create an OAuth client in the Trust credentials page of the admin console.
Create the client with Devices Core, Auth Keys, Services write scopes, and the tag tag:k8s-operator.
See https://tailscale.com/kb/1236/kubernetes-operator#prerequisites
EOF
}

variable "oauth_client_secret" {
  type        = string
  sensitive   = true
  description = <<EOF
Create an OAuth client in the Trust credentials page of the admin console.
Create the client with Devices Core, Auth Keys, Services write scopes, and the tag tag:k8s-operator.
See https://tailscale.com/kb/1236/kubernetes-operator#prerequisites
EOF
}

variable "tailnet_dns_name" {
  type        = string
  default     = ""
  description = "Enter the Tailnet DNS name listed in the DNS tab of your Tailscale admin console."
}
