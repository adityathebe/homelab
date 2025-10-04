Once the tunnel is created, run this command to get the tunnel token for `cloudflared`.

```sh
terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "cloudflare_zero_trust_tunnel_cloudflared.homelab") | .values.tunnel_token'
```
