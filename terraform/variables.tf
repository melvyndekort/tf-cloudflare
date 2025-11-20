variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tfstate_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "auth_domain" {
  type = string
}
