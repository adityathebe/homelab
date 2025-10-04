resource "cloudflare_record" "mx_record_1" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  content         = "in1-smtp.messagingengine.com"
  type            = "MX"
  priority        = 10
}

resource "cloudflare_record" "mx_record_2" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  content         = "in2-smtp.messagingengine.com"
  type            = "MX"
  priority        = 20
}

resource "cloudflare_record" "dkim_cname_1" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm1._domainkey"
  allow_overwrite = true
  content         = "fm1.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "dkim_cname_2" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm2._domainkey"
  allow_overwrite = true
  content         = "fm2.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "dkim_cname_3" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "fm3._domainkey"
  allow_overwrite = true
  content         = "fm3.adityathebe.com.dkim.fmhosted.com"
  type            = "CNAME"
  proxied         = false
}

resource "cloudflare_record" "spf" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "@"
  allow_overwrite = true
  content         = "v=spf1 include:spf.messagingengine.com ?all"
  type            = "TXT"
  proxied         = false
}

