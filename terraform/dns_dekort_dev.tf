resource "cloudflare_zone" "dekort_dev" {
  account = {
    id = local.account_id
  }

  name = "dekort.dev"
  type = "full"
}

resource "cloudflare_dns_record" "dekort_dev_bimi" {
  zone_id = cloudflare_zone.dekort_dev.id
  name    = "default._bimi"
  type    = "CNAME"
  ttl     = 300
  content = "_bimi.dekort_dev._d.easydmarc.pro"
}

resource "cloudflare_dns_record" "dekort_dev_github_verified_domain" {
  zone_id = cloudflare_zone.dekort_dev.id
  name    = "_github-pages-challenge-melvyndekort"
  type    = "TXT"
  ttl     = 300
  content = "f837d7931562884dd484f21c6fbb5f"
}
