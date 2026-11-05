resource "cloudflare_zero_trust_access_identity_provider" "github_oauth" {
  account_id = local.account_id
  name       = "GitHub OAuth"
  type       = "github"

  config = {
    client_id     = local.github_client_id
    client_secret = local.github_client_secret
  }
}

resource "cloudflare_zero_trust_access_identity_provider" "authentik_oidc" {
  account_id = local.account_id
  name       = "Authentik"
  type       = "oidc"

  config = {
    client_id     = local.authentik_client_id
    client_secret = local.authentik_client_secret
    auth_url      = "https://auth.mdekort.nl/application/o/authorize/"
    token_url     = "https://auth.mdekort.nl/application/o/token/"
    certs_url     = "https://auth.mdekort.nl/application/o/cloudflare-zero-trust/jwks/"

    scopes = [
      "openid",
      "email",
      "profile",
    ]
  }
}

resource "cloudflare_zero_trust_access_service_token" "github_actions" {
  account_id = local.account_id
  name       = "Github Actions"
}

resource "cloudflare_zero_trust_access_service_token" "grafana_cloud" {
  account_id = local.account_id
  name       = "Grafana Cloud"
}

resource "cloudflare_zero_trust_access_service_token" "hermes_agent" {
  account_id = local.account_id
  name       = "Hermes Agent"
}

# "Is this device running WARP and enrolled in this org?" — the check that lets
# an Access policy admit a device from any network without it having to match a
# source IP. Lives here rather than in a consumer repo because it is account-
# scoped and shared: hermes-agent is the first user, homelab can reuse it.
resource "cloudflare_zero_trust_device_posture_rule" "warp_enrolled" {
  account_id  = local.account_id
  name        = "WARP enrolled"
  description = "Device is running the WARP client and enrolled in this Zero Trust organisation"
  type        = "warp"
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
