locals {
  account_id           = local.secrets.cloudflare.account_id
  auth_user_pool_id    = data.terraform_remote_state.tf_cognito.outputs.auth_user_pool_id
  github_client_id     = local.secrets.cloudflare.github_client_id
  github_client_secret = local.secrets.cloudflare.github_client_secret
}
