terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

data "sops_file" "cloudflare_secrets" {
  source_file = "secret.sops.yaml"
}

provider "cloudflare" {
  api_token = data.sops_file.cloudflare_secrets.data["cloudflare_api_token"]
}

resource "cloudflare_record" "www" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "npm.home"
  allow_overwrite = true
  value           = "10.99.99.5"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "portainer" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "portainer.home"
  allow_overwrite = true
  value           = "10.99.99.5"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "adguard" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "adguard.home"
  allow_overwrite = true
  value           = "10.99.99.5"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "proxmox" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "pve.home"
  allow_overwrite = true
  value           = "10.99.99.4"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "truenas" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "nas.home"
  allow_overwrite = true
  value           = "10.99.99.51"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "wildcard" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "*.home"
  comment         = "For all apps hosted on kubernetes"
  allow_overwrite = true
  value           = "10.99.99.25"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "homepage" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "home"
  comment         = "Dashboard"
  allow_overwrite = true
  value           = "10.99.99.25"
  type            = "A"
  proxied         = false
}

resource "cloudflare_record" "mx_record_1" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  value           = "in1-smtp.messagingengine.com"
  type            = "MX"
  priority        = 10
}

resource "cloudflare_record" "mx_record_2" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  value           = "in2-smtp.messagingengine.com"
  type            = "MX"
  priority        = 20
}

resource "cloudflare_record" "dkim_cname_1" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm1._domainkey"
  allow_overwrite = true
  value           = "fm1.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "dkim_cname_2" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm2._domainkey"
  allow_overwrite = true
  value           = "fm2.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "dkim_cname_3" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm3._domainkey"
  allow_overwrite = true
  value           = "fm3.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "spf" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  value           = "v=spf1 include:spf.messagingengine.com ?all"
  type            = "TXT"
  proxied         = false
}
