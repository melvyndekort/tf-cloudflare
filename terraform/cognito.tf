resource "aws_cognito_user_pool_client" "cloudflare_zero_trust" {
  name         = "Cloudflare Zero Trust"
  user_pool_id = local.auth_user_pool_id

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]

  generate_secret = true
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  callback_urls = [
    "https://mdekort.cloudflareaccess.com/cdn-cgi/access/callback",
  ]
}
