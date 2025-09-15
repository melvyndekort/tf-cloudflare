data "http" "jwks" {
  url = "https://cognito-idp.eu-west-1.amazonaws.com/${local.auth_user_pool_id}/.well-known/jwks.json"
}

resource "cloudflare_zero_trust_access_identity_provider" "cognito_oidc" {
  account_id = local.account_id
  name       = "AWS Cognito OIDC"
  type       = "oidc"

  config = {
    client_id     = aws_cognito_user_pool_client.cloudflare_zero_trust.id
    client_secret = aws_cognito_user_pool_client.cloudflare_zero_trust.client_secret
    auth_url      = "https://${var.auth_domain}/oauth2/authorize"
    token_url     = "https://${var.auth_domain}/oauth2/token"
    certs_url     = "https://cognito-idp.eu-west-1.amazonaws.com/${local.auth_user_pool_id}/.well-known/jwks.json"
  }
}

resource "cloudflare_zero_trust_access_identity_provider" "github_oauth" {
  account_id = local.account_id
  name       = "GitHub OAuth"
  type       = "github"

  config = {
    client_id     = local.github_client_id
    client_secret = local.github_client_secret
  }
}

resource "cloudflare_zero_trust_access_service_token" "github_actions" {
  account_id = local.account_id
  name       = "Github Actions"
}

resource "cloudflare_zero_trust_access_group" "mdekort_users" {
  account_id = local.account_id
  name       = "mdekort users"

  include = [{
    email_domain = {
      domain = "mdekort.nl"
    }
  }]
}
