locals {
  dns_read     = "82e64a83756745bbbb1c9c2701bf816b"
  dns_write    = "4755a26eedb94da69e1066d98aa820be"
  pages_write  = "8d28297797f24fb8a0c332fe0866ec89"
  tunnel_read  = "efea2ab8357b47888938f101ae5e053f"
  tunnel_write = "c07321b023e944ff818fec44d8203567"
  access_read  = "7ea222f6d5064cfa89ea366d7c1fee89"
  access_write = "1e13c5124ca64b72b1969a67e8829049"
}

resource "cloudflare_api_token" "assets" {
  name   = "assets"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "cheatsheets" {
  name   = "cheatsheets"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "ignition" {
  name   = "ignition"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "mdekort_nl" {
  name   = "mdekort-nl"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "melvyn_dev" {
  name   = "melvyn-dev"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.melvyn_dev.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "mta_sts" {
  name   = "mta-sts"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "startpage" {
  name   = "startpage"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "example" {
  name   = "example-melvyn-dev"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.melvyn_dev.id}" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.pages_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
  }]
}

resource "cloudflare_api_token" "lmgateway" {
  name   = "lmgateway"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
  }]
}

resource "cloudflare_api_token" "traefik" {
  name   = "traefik"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.dns_read
      }, {
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
  }]
}

resource "cloudflare_api_token" "lmserver" {
  name   = "lmserver"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = local.tunnel_read
      }, {
      id = local.tunnel_write
      }, {
      id = local.access_read
      }, {
      id = local.access_write
    }]
    resources = {
      "com.cloudflare.api.account.*" = "*"
    }
    }, {
    effect = "allow"
    permission_groups = [{
      id = local.dns_read
      }, {
      id = local.dns_write
    }]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.mdekort.id}" = "*"
    }
  }]
}
