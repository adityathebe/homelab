terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
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
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "npm.home"
  value   = "192.168.1.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "portainer" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "portainer.home"
  value   = "192.168.1.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "adguard" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "adguard.home"
  value   = "192.168.1.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "proxmox" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "pve.home"
  allow_overwrite = true
  value   = "192.168.1.4"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "truenas" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "nas.home"
  allow_overwrite = true
  value   = "192.168.1.51"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "wildcard" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "*.home"
  comment = "For all apps hosted on kubernetes"
  allow_overwrite = true
  value   = "192.168.1.3"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homepage" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "home"
  comment = "Dashboard"
  allow_overwrite = true
  value   = "192.168.1.3"
  type    = "A"
  proxied = false
}
