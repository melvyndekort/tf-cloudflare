resource "random_id" "tunnel_secret" {
  byte_length = 32
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id    = local.account_id
  name          = "mdekort"
  tunnel_secret = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "home_network" {
  account_id         = local.account_id
  name               = "home-network"
  comment            = "Home network access via WARP"
  is_default_network = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "home_network_ipv4" {
  account_id         = local.account_id
  tunnel_id          = cloudflare_zero_trust_tunnel_cloudflared.main.id
  network            = "10.204.0.0/16"
  comment            = "Route home network IPv4 traffic through tunnel"
  virtual_network_id = cloudflare_zero_trust_tunnel_cloudflared_virtual_network.home_network.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "home_network_ipv6" {
  account_id         = local.account_id
  tunnel_id          = cloudflare_zero_trust_tunnel_cloudflared.main.id
  network            = "2a02:a45b:51f6::/48"
  comment            = "Route home network IPv6 traffic through tunnel"
  virtual_network_id = cloudflare_zero_trust_tunnel_cloudflared_virtual_network.home_network.id
}
