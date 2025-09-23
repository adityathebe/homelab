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
      hostname = "${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "movies.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "jellyfin.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "movie-request.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "jellyseerr.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "notes.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "notes.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "movies.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "movary.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "rss.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "rss.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "music.${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "navidrome.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "vehicle.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      path     = ""
      service  = "http://10.99.99.25"
      origin_request {
        http_host_header = "vehicle.${data.sops_file.cloudflare_secrets.data["homelab_domain"]}"
      }
    }
    ingress_rule {
      hostname = "*"
      service  = "http_status:503"
    }
  }
}

resource "cloudflare_record" "homelab_root" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "@"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_movies" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "movies"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_jellyseerr" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "movie-request"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_movary" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "movies"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_silverbullet" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "notes"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_fresh_rss" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "rss"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "homelab_navidrome" {
  zone_id = data.sops_file.cloudflare_secrets.data["cloudflare_zone_id"]
  name    = "music"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}


resource "cloudflare_record" "homelab_vehicle" {
  zone_id = data.sops_file.cloudflare_secrets.data["homelab_cloudflare_zone_id"]
  name    = "vehicle"
  content = cloudflare_tunnel.homelab.cname
  type    = "CNAME"
  proxied = true
}
