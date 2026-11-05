locals {
  account_id              = local.secrets.cloudflare.account_id
  auth_user_pool_id       = data.terraform_remote_state.tf_cognito.outputs.auth_user_pool_id
  github_client_id        = local.secrets.cloudflare.github_client_id
  github_client_secret    = local.secrets.cloudflare.github_client_secret
  authentik_client_id     = local.secrets.cloudflare.authentik_client_id
  authentik_client_secret = local.secrets.cloudflare.authentik_client_secret
  home_ipv4               = "82.170.177.87"
  compute1_ipv6           = "2a02:a45b:51f6:10::21"
}
