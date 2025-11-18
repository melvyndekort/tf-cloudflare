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
  content = "82.170.177.87"
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
