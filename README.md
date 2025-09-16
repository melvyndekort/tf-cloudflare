# tf-cloudflare

Terraform configuration for centrally managing Cloudflare resources including DNS records, Zero Trust settings, and API tokens. This project provides a GitOps approach to Cloudflare infrastructure management with secure secret handling via AWS KMS encryption.

## Prerequisites

- **AWS CLI** (v2.0+) configured with appropriate credentials
- **Terraform** (v1.0+) installed and available in PATH
- **Access to AWS KMS** with permissions to encrypt/decrypt using the `generic` key alias
- **Cloudflare account** with API access
- **GitHub repository** (if using the GitHub OIDC integration)

### Required AWS Permissions

Your AWS credentials need the following permissions:
- `kms:Encrypt` and `kms:Decrypt` on the KMS key with alias `generic`
- `sts:AssumeRole` for GitHub OIDC (if using CI/CD)
- Standard Terraform state management permissions

## Project Structure

```
├── bootstrap/                    # Initial AWS setup (GitHub OIDC role)
│   ├── github-oidc-role.tf      # IAM role for GitHub Actions
│   └── providers.tf             # AWS provider configuration
├── terraform/                   # Main Cloudflare configuration
│   ├── dns_*.tf                # DNS zone configurations (per domain)
│   ├── api_tokens.tf           # Cloudflare API token management
│   ├── zero_trust.tf           # Zero Trust configuration
│   ├── cognito.tf              # AWS Cognito integration
│   ├── secrets.tf              # Secret variable definitions
│   ├── secrets.yaml.encrypted  # Encrypted secrets (KMS)
│   ├── main.tf                 # Main configuration and locals
│   ├── variables.tf            # Input variables
│   ├── output.tf               # Output values
│   └── providers.tf            # Provider configurations
├── .github/workflows/           # GitHub Actions CI/CD
└── Makefile                    # Automation commands
```

### DNS Zone Files
Each domain has its own DNS configuration file:
- `dns_melvyn_dev.tf` - Configuration for melvyn.dev domain
- `dns_mdekort_nl.tf` - Configuration for mdekort.nl domain
- `dns_dekort_dev.tf` - Configuration for dekort.dev domain

## Setup

### Initial Setup (First Time)

1. **Authenticate with AWS:**
   ```bash
   # Using assume role helper (if available)
   assume
   
   # Or configure AWS CLI directly
   aws configure
   
   # Verify authentication
   aws sts get-caller-identity
   ```

2. **Bootstrap AWS resources** (run once per AWS account):
   ```bash
   cd bootstrap
   terraform init
   terraform plan  # Review the changes
   terraform apply
   ```
   
   This creates:
   - GitHub OIDC identity provider
   - IAM role for GitHub Actions
   - Required permissions for Terraform operations

3. **Initialize main Terraform configuration:**
   ```bash
   cd terraform
   terraform init
   ```

4. **Create your secrets file:**
   ```bash
   # Create a secrets.yaml file with your Cloudflare credentials
   cat > terraform/secrets.yaml << EOF
   cloudflare_api_token: "your-cloudflare-api-token"
   cloudflare_account_id: "your-account-id"
   # Add other sensitive values as needed
   EOF
   
   # Encrypt the secrets
   make encrypt
   ```

## Usage

### Daily Workflow

1. **Decrypt secrets before making changes:**
   ```bash
   make decrypt
   ```
   This decrypts `secrets.yaml.encrypted` to `terraform/secrets.yaml`

2. **Plan and apply Terraform changes:**
   ```bash
   cd terraform
   terraform plan    # Review planned changes
   terraform apply   # Apply changes
   ```

3. **Encrypt secrets after making changes:**
   ```bash
   make encrypt
   ```
   This encrypts `terraform/secrets.yaml` and removes the plaintext file

4. **Clean up (optional):**
   ```bash
   make clean_secrets  # Removes decrypted secrets.yaml
   ```

### Common Operations

#### Adding a New DNS Record

1. Edit the appropriate DNS zone file (e.g., `dns_melvyn_dev.tf`):
   ```hcl
   resource "cloudflare_dns_record" "melvyn_dev_new_record" {
     zone_id = cloudflare_zone.melvyn_dev.id
     name    = "api"  # Creates api.melvyn.dev
     type    = "A"
     ttl     = 300
     content = "192.168.1.100"
   }
   ```

2. Apply the changes:
   ```bash
   cd terraform
   terraform plan
   terraform apply
   ```

#### Adding a New Domain

1. Create a new DNS zone file (e.g., `dns_example_com.tf`):
   ```hcl
   resource "cloudflare_zone" "example_com" {
     account = {
       id = local.account_id
     }
     name = "example.com"
     type = "full"
   }
   
   resource "cloudflare_dns_record" "example_com_root" {
     zone_id = cloudflare_zone.example_com.id
     name    = "@"
     type    = "A"
     ttl     = 300
     content = "192.168.1.1"
   }
   ```

2. Apply the configuration:
   ```bash
   cd terraform
   terraform plan
   terraform apply
   ```

#### Updating Secrets

1. Decrypt current secrets:
   ```bash
   make decrypt
   ```

2. Edit `terraform/secrets.yaml`:
   ```yaml
   cloudflare_api_token: "new-token-value"
   cloudflare_account_id: "account-id"
   new_secret: "additional-secret"
   ```

3. Update `terraform/secrets.tf` if adding new variables:
   ```hcl
   variable "new_secret" {
     type      = string
     sensitive = true
   }
   ```

4. Encrypt the updated secrets:
   ```bash
   make encrypt
   ```

### Makefile Commands

| Command | Description |
|---------|-------------|
| `make decrypt` | Decrypt secrets.yaml.encrypted to secrets.yaml |
| `make encrypt` | Encrypt secrets.yaml to secrets.yaml.encrypted and remove plaintext |
| `make clean_secrets` | Remove decrypted secrets.yaml file |

**Note:** All Makefile commands require an active AWS session (`AWS_SESSION_TOKEN` must be set).

## Security

### Secret Management

- **Encryption**: All secrets are encrypted using AWS KMS with the key alias `generic`
- **Encryption Context**: Uses `target=tf-cloudflare` for additional security and access control
- **Version Control**: Only encrypted files (`secrets.yaml.encrypted`) are committed to Git
- **Automatic Cleanup**: The `encrypt` command automatically removes plaintext files

### Best Practices

- ✅ **DO**: Always run `make encrypt` after updating secrets
- ✅ **DO**: Use `make clean_secrets` to remove temporary plaintext files
- ✅ **DO**: Verify AWS authentication before running commands
- ❌ **DON'T**: Commit `secrets.yaml` (plaintext) to version control
- ❌ **DON'T**: Share decrypted secrets outside the secure environment
- ❌ **DON'T**: Run Terraform commands without proper AWS credentials

### Git Ignore

The `.gitignore` file prevents accidental commits of sensitive files:
```
terraform/secrets.yaml
.terraform/
*.tfstate*
```

### CI/CD Security

GitHub Actions uses OIDC for secure AWS authentication without storing long-lived credentials:
- No AWS access keys stored in GitHub secrets
- Short-lived tokens with minimal required permissions
- Automatic credential rotation

## Troubleshooting

### Common Issues

**"Not logged in" error:**
```bash
# Ensure AWS session is active
aws sts get-caller-identity
# If needed, re-authenticate
assume  # or aws configure
```

**KMS access denied:**
```bash
# Verify KMS permissions
aws kms describe-key --key-id alias/generic
```

**Terraform state lock:**
```bash
# If state is locked, check for running processes
# Force unlock only if necessary (be careful!)
terraform force-unlock <lock-id>
```

**Missing secrets.yaml:**
```bash
# Decrypt secrets first
make decrypt
# Then run terraform commands
```
