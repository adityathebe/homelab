resource "cloudflare_tunnel" "homelab" {
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  name       = "aditya"
  secret     = data.sops_file.cloudflare_secrets.data["cloudflare_tunnel_secret"]
}

resource "cloudflare_tunnel_config" "homelab" {
  account_id = data.sops_file.cloudflare_secrets.data["cloudflare_account_id"]
  tunnel_id  = cloudflare_tunnel.homelab.id

  config {
    ingress_rule {
      hostname = "movies.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "movary.home.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      }
    }
    ingress_rule {
      hostname = "freshrss.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "rss.home.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      }
    }
    ingress_rule {
      hostname = "music.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "navidrome.home.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      }
    }
    ingress_rule {
      hostname = "vikunja.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "vikunja.home.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      }
    }
    ingress_rule {
      hostname = "*"
      service  = "http_status:503"
    }
  }
}

resource "cloudflare_record" "homelab_movary" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "movies"
  allow_overwrite = true
  value           = cloudflare_tunnel.homelab.cname
  type            = "CNAME"
  proxied         = true
}

resource "cloudflare_record" "homelab_fresh_rss" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "freshrss"
  allow_overwrite = true
  value           = cloudflare_tunnel.homelab.cname
  type            = "CNAME"
  proxied         = true
}

resource "cloudflare_record" "homelab_navidrome" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "music"
  allow_overwrite = true
  value           = cloudflare_tunnel.homelab.cname
  type            = "CNAME"
  proxied         = true
}

resource "cloudflare_record" "homelab_vikunja" {
  zone_id         = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name            = "vikunja"
  allow_overwrite = true
  value           = cloudflare_tunnel.homelab.cname
  type            = "CNAME"
  proxied         = true
}
