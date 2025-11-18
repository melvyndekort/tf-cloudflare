data "cloudflare_api_token_permission_groups_list" "all" {}

locals {
  permission_groups_by_name = { for group in data.cloudflare_api_token_permission_groups_list.all.result : group.name => group.id... }
  permission_groups         = { for name, ids in local.permission_groups_by_name : name => ids[0] }

  # Zone-specific resources
  mdekort_nl_resources = {
    "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
  }

  melvyn_dev_resources = {
    "com.cloudflare.api.account.zone.${cloudflare_zone.melvyn_dev.id}" = "*"
  }

  dekort_dev_resources = {
    "com.cloudflare.api.account.zone.${cloudflare_zone.dekort_dev.id}" = "*"
  }

  # Account-level resources for pages/tunnels
  account_resources = {
    "com.cloudflare.api.account.${local.account_id}" = "*"
  }
}

resource "cloudflare_api_token" "assets" {
  name   = "assets"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "cheatsheets" {
  name   = "cheatsheets"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "ignition" {
  name   = "ignition"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "mdekort_nl" {
  name   = "mdekort-nl"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "melvyn_dev" {
  name   = "melvyn-dev"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.melvyn_dev_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "mta_sts" {
  name   = "mta-sts"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "startpage" {
  name   = "startpage"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "example" {
  name   = "example-melvyn-dev"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.melvyn_dev_resources
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = local.account_resources
  }]
}

resource "cloudflare_api_token" "minecraft" {
  name   = "minecraft"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.dekort_dev_resources
  }]
}

resource "cloudflare_api_token" "lmgateway" {
  name   = "lmgateway"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
  }]
}

resource "cloudflare_api_token" "tf_aws" {
  name   = "tf-aws"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = local.mdekort_nl_resources
  }]
}

resource "cloudflare_api_token" "traefik" {
  name   = "traefik"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Zone Read"]
      }, {
      id = local.permission_groups["DNS Write"]
    }]
    resources = merge(local.mdekort_nl_resources, local.melvyn_dev_resources, local.dekort_dev_resources)
  }]
}

resource "cloudflare_api_token" "email_infra" {
  name   = "email-infra"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = merge(local.mdekort_nl_resources, local.melvyn_dev_resources, local.dekort_dev_resources)
  }]
}




