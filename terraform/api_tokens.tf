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

  # Cloudflare renamed Argo Tunnel to Cloudflare Tunnel, but the token API has
  # historically kept returning the legacy permission-group name. Their docs
  # list the UI label ("Cloudflare Tunnel Edit") while this data source returns
  # API labels ("DNS Write"), so neither source settles it. Take whichever name
  # this account actually exposes rather than hard-coding a guess that would
  # fail as an unhelpful "Invalid index" at plan time.
  tunnel_write_permission_group = try(
    local.permission_groups["Cloudflare Tunnel Write"],
    local.permission_groups["Argo Tunnel Write"],
  )
}

resource "cloudflare_api_token" "assets" {
  name   = "assets"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
  }]
}

resource "cloudflare_api_token" "cognito" {
  name   = "cognito"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = jsonencode(local.mdekort_nl_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.melvyn_dev_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.melvyn_dev_resources)
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Pages Write"]
    }]
    resources = jsonencode(local.account_resources)
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
    resources = jsonencode(local.dekort_dev_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
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
    resources = jsonencode(local.mdekort_nl_resources)
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
    resources = jsonencode(merge(local.mdekort_nl_resources, local.melvyn_dev_resources, local.dekort_dev_resources))
  }]
}

resource "cloudflare_api_token" "network_monitor" {
  name   = "network-monitor"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["DNS Write"]
    }]
    resources = jsonencode(local.mdekort_nl_resources)
  }]
}

resource "cloudflare_api_token" "pihole_1" {
  name   = "pihole-1"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.permission_groups["Zone Read"]
      }, {
      id = local.permission_groups["DNS Write"]
    }]
    resources = jsonencode(local.mdekort_nl_resources)
  }]
}

# hermes-agent manages its own Cloudflare Tunnel and the Access applications
# in front of it, so it needs account-scoped tunnel/Access permissions on top
# of the zone-scoped DNS Write it already had. Deliberately NOT switched to the
# global API key the way homelab is: hermes-agent is the internet-adjacent repo
# and its agent has an unsandboxed shell, so its pipeline credential stays
# least-privilege.
resource "cloudflare_api_token" "hermes_agent" {
  name   = "hermes-agent"
  status = "active"

  policies = [
    {
      effect = "allow"
      permission_groups = [{
        id = local.permission_groups["DNS Write"]
      }]
      resources = jsonencode(local.mdekort_nl_resources)
    },
    {
      effect = "allow"
      permission_groups = [
        { id = local.tunnel_write_permission_group },
        { id = local.permission_groups["Access: Apps and Policies Write"] },
      ]
      resources = jsonencode(local.account_resources)
    },
  ]
}