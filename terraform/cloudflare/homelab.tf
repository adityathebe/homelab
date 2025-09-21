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
