resource "cloudflare_dns_record" "homelab_truenas" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = format("nas.%s", data.sops_file.cloudflare_secrets.data["homelab_domain"])
  content = "10.99.99.51"
  type    = "A"
  ttl     = 1
  proxied = false
}
