resource "cloudflare_zone" "mdekort" {
  account = {
    id = local.account_id
  }

  name = "mdekort.nl"
  type = "full"
}

resource "cloudflare_dns_record" "mdekort_github_verified_domain" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "_github-pages-challenge-melvyndekort"
  type    = "TXT"
  ttl     = 300
  content = "c1fba7e1ffc99730e955d311077ef5"
}

resource "cloudflare_dns_record" "mdekort_vpn6_AAAA" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "vpn6"
  type    = "AAAA"
  ttl     = 300
  content = "2a02:a45b:51f6:150::1"
}

resource "cloudflare_dns_record" "mdekort_home_A" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "home"
  type    = "A"
  ttl     = 300
  content = local.home_ipv4
}

resource "cloudflare_dns_record" "mdekort_vpn" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "vpn"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  content = "home.mdekort.nl"
}

resource "cloudflare_dns_record" "mdekort_ssh" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "ssh"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  content = "home.mdekort.nl"
}

resource "cloudflare_dns_record" "mdekort_rustdesk_A" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "rustdesk"
  type    = "A"
  ttl     = 300
  content = local.home_ipv4
}

resource "cloudflare_dns_record" "mdekort_rustdesk_AAAA" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "rustdesk"
  type    = "AAAA"
  ttl     = 300
  content = local.compute1_ipv6
}

# Content is kept up to date by the hermes-agent Lambda
# (hermes-agent-update-dns) whenever the ECS task starts - Terraform only
# owns the record's existence, not its value.
resource "cloudflare_dns_record" "hermes_A" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "hermes"
  type    = "A"
  ttl     = 60
  content = "192.0.2.1" # placeholder (TEST-NET-1) - overwritten by the Lambda

  lifecycle {
    ignore_changes = [content]
  }
}

resource "cloudflare_dns_record" "hermes_AAAA" {
  zone_id = cloudflare_zone.mdekort.id
  name    = "hermes"
  type    = "AAAA"
  ttl     = 60
  content = "100::1" # placeholder (discard-only range) - overwritten by the Lambda

  lifecycle {
    ignore_changes = [content]
  }
}
