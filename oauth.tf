// Detect if var.oauth_client_id / var.oauth_client_secret is a `{{ secret(<ref>) }}` reference vs. a plain value.
// `secret_refs["<KEY>"]` is populated only when the value matches the secret-ref pattern.
data "ns_env_variables" "interpolation" {
  input_env_variables = {}
  input_secrets = {
    OAUTH_CLIENT_ID     = var.oauth_client_id
    OAUTH_CLIENT_SECRET = var.oauth_client_secret
  }
}

locals {
  oauth_client_id_secret_ref     = lookup(data.ns_env_variables.interpolation.secret_refs, "OAUTH_CLIENT_ID", "")
  oauth_client_secret_secret_ref = lookup(data.ns_env_variables.interpolation.secret_refs, "OAUTH_CLIENT_SECRET", "")
}

// When var.oauth_client_id is a secret reference, pull the value from Google Secret Manager.
data "google_secret_manager_secret_version" "oauth_client_id" {
  count = local.oauth_client_id_secret_ref != "" ? 1 : 0

  secret = local.oauth_client_id_secret_ref
}

// When var.oauth_client_secret is a secret reference, pull the value from Google Secret Manager.
data "google_secret_manager_secret_version" "oauth_client_secret" {
  count = local.oauth_client_secret_secret_ref != "" ? 1 : 0

  secret = local.oauth_client_secret_secret_ref
}

locals {
  oauth_client_id     = length(data.google_secret_manager_secret_version.oauth_client_id) > 0 ? nonsensitive(data.google_secret_manager_secret_version.oauth_client_id[0].secret_data) : var.oauth_client_id
  oauth_client_secret = length(data.google_secret_manager_secret_version.oauth_client_secret) > 0 ? data.google_secret_manager_secret_version.oauth_client_secret[0].secret_data : var.oauth_client_secret
}
