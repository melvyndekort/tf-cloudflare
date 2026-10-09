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

  # permission_groups above collapses same-named groups with ids[0]. Cloudflare
  # publishes the same name at more than one scope (an account-scoped and a
  # zone-scoped "Access: Apps and Policies Write", for instance), so that pick
  # is arbitrary. It is harmless for the zone-scoped DNS/Pages tokens that
  # predate this, but for an account-scoped policy it can attach a zone-scoped
  # permission id, which the API accepts and then declines to honour: reads
  # succeed and writes fail 403 auth.forbidden, with nothing in the token
  # definition looking wrong. Select on scope explicitly instead.
  account_permission_groups = {
    for g in data.cloudflare_api_token_permission_groups_list.all.result :
    g.name => g.id... if contains(g.scopes, "com.cloudflare.api.account")
  }

  # Names vary across Cloudflare's own sources - the docs show UI labels
  # ("Cloudflare Tunnel Edit") while this data source returns API labels, and
  # the tunnel group may still carry its pre-rename "Argo" name. List every
  # candidate and keep the ones this account actually exposes, so a name that
  # does not exist is skipped rather than failing the plan on an index error.
  hermes_agent_permission_names = [
    "Cloudflare Tunnel Write",
    "Argo Tunnel Write",
    "Access: Apps and Policies Write",
    "Access: Device Posture Write",
    "Access: Organizations, Identity Providers, and Groups Write",
  ]

  hermes_agent_permission_ids = distinct([
    for n in local.hermes_agent_permission_names :
    local.account_permission_groups[n][0]
    if contains(keys(local.account_permission_groups), n)
  ])

  # Same scope problem as above, for the zone-scoped half of the read-only
  # token below: pick the zone-scoped group explicitly.
  zone_permission_groups = {
    for g in data.cloudflare_api_token_permission_groups_list.all.result :
    g.name => g.id... if contains(g.scopes, "com.cloudflare.api.account.zone")
  }

  hermes_agent_readonly_zone_permission_names = [
    "Zone Read",
    "DNS Read",
  ]

  hermes_agent_readonly_zone_permission_ids = distinct([
    for n in local.hermes_agent_readonly_zone_permission_names :
    local.zone_permission_groups[n][0]
    if contains(keys(local.zone_permission_groups), n)
  ])

  # Candidate names, skipped when this account does not expose them (see the
  # note on hermes_agent_permission_names). A skipped name means a silently
  # narrower token, so check the applied policies rather than trusting this.
  hermes_agent_readonly_account_permission_names = [
    "Access: Apps and Policies Read",
    "Access: Organizations, Identity Providers, and Groups Read",
    "Access: Device Posture Read",
    "Cloudflare Tunnel Read",
    "Argo Tunnel Read",
    "Pages Read",
    "Account Settings Read",
  ]

  hermes_agent_readonly_account_permission_ids = distinct([
    for n in local.hermes_agent_readonly_account_permission_names :
    local.account_permission_groups[n][0]
    if contains(keys(local.account_permission_groups), n)
  ])
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
        for id in local.hermes_agent_permission_ids : { id = id }
      ]
      resources = jsonencode(local.account_resources)
    },
  ]
}
# Read-only counterpart to hermes_agent, for the lookups the agent does at
# runtime (DNS records, Access apps and policies, tunnels, Pages). It exists so
# the agent does not need the write-capable pipeline credential above, or a
# hosted MCP server that exposes write endpoints. Changes go through PRs here.
resource "cloudflare_api_token" "hermes_agent_readonly" {
  name   = "hermes-agent-readonly"
  status = "active"

  policies = [
    {
      effect = "allow"
      permission_groups = [
        for id in local.hermes_agent_readonly_zone_permission_ids : { id = id }
      ]
      resources = jsonencode(merge(
        local.mdekort_nl_resources,
        local.melvyn_dev_resources,
        local.dekort_dev_resources,
      ))
    },
    {
      effect = "allow"
      permission_groups = [
        for id in local.hermes_agent_readonly_account_permission_ids : { id = id }
      ]
      resources = jsonencode(local.account_resources)
    },
  ]
}
