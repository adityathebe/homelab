resource "cloudflare_dns_record" "mx_record_1" {
  zone_id  = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name     = "adityathebe.com"
  content  = "in1-smtp.messagingengine.com"
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_dns_record" "mx_record_2" {
  zone_id  = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name     = "adityathebe.com"
  content  = "in2-smtp.messagingengine.com"
  type     = "MX"
  ttl      = 1
  priority = 20
}

resource "cloudflare_dns_record" "dkim_cname_1" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "fm1._domainkey.adityathebe.com"
  content = "fm1.adityathebe.com.dkim.fmhosted.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "dkim_cname_2" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "fm2._domainkey.adityathebe.com"
  content = "fm2.adityathebe.com.dkim.fmhosted.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "dkim_cname_3" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "fm3._domainkey.adityathebe.com"
  content = "fm3.adityathebe.com.dkim.fmhosted.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "spf" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "adityathebe.com"
  content = "v=spf1 include:spf.messagingengine.com ?all"
  type    = "TXT"
  ttl     = 1
  proxied = false
}
