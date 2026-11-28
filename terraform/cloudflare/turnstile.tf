resource "cloudflare_turnstile_widget" "fern" {
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  name       = "fern"
  domains    = [data.sops_file.cloudflare_secrets.data["fern_domain"]]
  mode       = "managed"
  region     = "world"
}

output "fern_turnstile_sitekey" {
  value = cloudflare_turnstile_widget.fern.sitekey
}

output "fern_turnstile_secret" {
  value     = cloudflare_turnstile_widget.fern.secret
  sensitive = true
}
