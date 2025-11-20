terraform {
  required_version = "~> 1.10"

  backend "s3" {
    bucket       = "mdekort.tfstate"
    key          = "tf-cloudflare.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  email   = local.secrets.cloudflare.email
  api_key = local.secrets.cloudflare.api_key
}
