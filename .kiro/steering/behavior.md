# tf-cloudflare

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Cloud Engineer specializing in Terraform and Cloudflare.

## Critical: This Repo Is a Central Dependency

This repo provides API tokens and configuration to many other repos via Terraform remote state outputs. Changes to outputs can break downstream repos.

Consumers:
- `assets`, `cheatsheets`, `startpage`, `melvyn-dev`, `example.melvyn.dev` — site-specific API tokens
- `email-infra` — email + API key for DNS management
- `homelab` — tunnel token, GitHub Actions client ID/secret for Portainer webhooks
- `network-monitor` — API token for DNS
- `tf-cognito` — API token for DNS validation
- `tf-github` — Cloudflare secrets for distribution to repos
- `ignition` — API token

## Repository Structure

- `terraform/api_tokens.tf` — Per-service Cloudflare API tokens
- `terraform/dns_mdekort_nl.tf`, `dns_melvyn_dev.tf`, `dns_dekort_dev.tf` — DNS records per domain
- `terraform/tunnel.tf` — Cloudflare Tunnel (used by homelab Traefik)
- `terraform/zero_trust.tf` — Zero Trust / Access policies
- `terraform/cognito.tf` — Cognito integration for Zero Trust
- `terraform/secrets.tf` — KMS-encrypted secrets loading
- `terraform/output.tf` — Outputs consumed by many other repos
- `Makefile` — `decrypt`, `encrypt`, `clean_secrets`, `tunnel-token`

## Terraform Details

- Backend: S3 key `tf-cloudflare.tfstate` in `mdekort-tfstate-075673041815`
- Providers: AWS `~> 6.0`, Cloudflare `~> 5.0`
- Secrets: KMS context `target=tf-cloudflare`

## Related Repositories

- `~/src/melvyndekort/tf-aws` — AWS account management, KMS key
- `~/src/melvyndekort/tf-github` — Distributes Cloudflare secrets to repos
- `~/src/melvyndekort/tf-cognito` — Consumes API token for DNS validation
- `~/src/melvyndekort/homelab` — Uses tunnel token and GitHub Actions client credentials
