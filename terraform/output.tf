output "mdekort_zone_id" {
  value = cloudflare_zone.mdekort.id
}

output "melvyn_dev_zone_id" {
  value = cloudflare_zone.melvyn_dev.id
}

output "dekort_dev_zone_id" {
  value = cloudflare_zone.dekort_dev.id
}

output "api_token_minecraft" {
  value     = cloudflare_api_token.minecraft.value
  sensitive = true
}

output "api_token_lmgateway" {
  value     = cloudflare_api_token.lmgateway.value
  sensitive = true
}

output "api_token_traefik" {
  value     = cloudflare_api_token.traefik.value
  sensitive = true
}

output "api_token_example" {
  value     = cloudflare_api_token.example.value
  sensitive = true
}

output "api_token_assets" {
  value     = cloudflare_api_token.assets.value
  sensitive = true
}

output "api_token_cheatsheets" {
  value     = cloudflare_api_token.cheatsheets.value
  sensitive = true
}

output "api_token_ignition" {
  value     = cloudflare_api_token.ignition.value
  sensitive = true
}

output "api_token_mdekort_nl" {
  value     = cloudflare_api_token.mdekort_nl.value
  sensitive = true
}

output "api_token_melvyn_dev" {
  value     = cloudflare_api_token.melvyn_dev.value
  sensitive = true
}

output "api_token_mta_sts" {
  value     = cloudflare_api_token.mta_sts.value
  sensitive = true
}

output "api_token_startpage" {
  value     = cloudflare_api_token.startpage.value
  sensitive = true
}

output "api_token_lmserver" {
  value     = cloudflare_api_token.lmserver.value
  sensitive = true
}

# output "permissions_account" {
#   value = data.cloudflare_api_token_permission_groups_list.all.account
# }

# output "permissions_zone" {
#   value = data.cloudflare_api_token_permission_groups_list.all.zone
# }

output "github_actions_client_id" {
  value = cloudflare_zero_trust_access_service_token.github_actions.client_id
}

output "github_actions_client_secret" {
  value     = cloudflare_zero_trust_access_service_token.github_actions.client_secret
  sensitive = true
}
