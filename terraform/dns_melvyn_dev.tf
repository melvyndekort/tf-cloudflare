resource "cloudflare_zone" "melvyn_dev" {
  account = {
    id = local.account_id
  }

  name = "melvyn.dev"
  type = "full"
}

resource "cloudflare_dns_record" "melvyn_dev_github_verified_domain" {
  zone_id = cloudflare_zone.melvyn_dev.id
  name    = "_github-pages-challenge-melvyndekort"
  type    = "TXT"
  ttl     = 300
  content = "8fb798c952a406f3402b695447ec43"
}
