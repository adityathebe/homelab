resource "cloudflare_record" "homelab_npm" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "npm"
  content = "10.99.99.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homelab_portainer" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "portainer"
  content = "10.99.99.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homelab_adguard" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "adguard"
  content = "10.99.99.5"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homelab_proxmox" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "pve"
  content = "10.99.99.4"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homelab_truenas" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "nas"
  content = "10.99.99.51"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "homelab_wildcard" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "*"
  comment = "For all apps hosted on kubernetes"
  content = "10.99.99.25"
  type    = "A"
  proxied = false
}
