resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  name       = "homelab"
  secret     = data.sops_file.cloudflare_secrets.data["cloudflare_tunnel_secret"]
}