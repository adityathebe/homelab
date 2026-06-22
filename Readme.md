<h1 align="center">
  Homelab
</h1>

<p align="center">
  <a href="https://github.com/k8s-at-home" alt="Image used with permission from k8s-at-home"><img alt="Image used with permission from k8s-at-home" src="https://avatars.githubusercontent.com/u/61287648" /></a>
</p>

<p align="center">
  <a href="https://k3s.io/">
    <img alt="k3s" src="https://img.shields.io/badge/k3s-v1.34.1-orange?logo=kubernetes&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/adityathebe/homelab/commits/master">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/adityathebe/homelab?logo=git&logoColor=white&color=purple&style=flat-square">
  </a>
</p>

<p align="center">
Using GitOps principals and workflow to manage a lightweight <a href="https://k3s.io">k3s</a> cluster.
</p>

# Infrastructure

I've used Techno Tim's [k3s-ansible](https://github.com/techno-tim/k3s-ansible) playbook to deploy a 4 node cluster: one control-plane node and three workers across one Proxmox host plus two bare-metal Kubernetes nodes.

![Dashboard](.github/images/homepage.png)

## Servers

### 1. Proxmox Host

| Hostname | Model        | CPU        | RAM  | Storage    | Proxmox |
| -------- | ------------ | ---------- | ---- | ---------- | ------- |
| wilshere | Beelink EQ14 | Intel N150 | 16GB | 500GB NVMe | 9.2.3   |

### 2. Kubernetes Nodes

| Node     | Role          | Host type  | RAM  | IP          |
| -------- | ------------- | ---------- | ---- | ----------- |
| arteta   | control-plane | Proxmox VM | 6GB  | 10.99.99.11 |
| saliba   | worker        | Proxmox VM | 6GB  | 10.99.99.10 |
| jhapa    | worker        | bare metal | 16GB | 10.99.99.13 |
| lalitpur | worker        | bare metal | 16GB | 10.99.99.14 |

### 3. Ugreen NAS DH4300 Plus

| Description | Spec         |
| ----------- | ------------ |
| Server      | Ugreen NAS   |
| IP          | 10.99.99.151 |

### 4. TrueNAS Scale

TrueNAS Scale acts as a backup server only.

| Description | Spec                           |
| ----------- | ------------------------------ |
| Server      | SONY VAIO - SVE14126CXB (2012) |
| RAM         | 8GB _(maxed out)_              |
| CPU         | Intel i5-3210M                 |
| SSD (os)    | 128GB                          |
| SDD         | 1TB                            |

## Kubernetes Storage

| Use case                   | Storage type           | Notes                                                                |
| -------------------------- | ---------------------- | -------------------------------------------------------------------- |
| Application PVCs           | Longhorn               | Default distributed block storage for most app data/config volumes.  |
| Local/single-replica PVCs  | Longhorn variants      | `longhorn-local` and `longhorn-single` for selected workloads.       |
| Shared RWX PVCs            | SMB CSI                | Used for shared volumes such as Immich libraries and Gickup backups. |
| Media/music library mounts | Direct NFS pod volumes | Used by media/music apps against Ugreen NAS `10.99.99.151`.          |

There is no NFS `StorageClass` in the cluster. NFS is still used directly in selected HelmReleases for media paths such as `/volume2/media`, `/volume2/media/movies`, `/volume2/media/shows`, and `/volume2/media/music`.

![Server](.github/images/IMG_9856.jpg)
_Beelink mini PCs & TrueNAS server_

# Setting it up

1. Create flux namespace and the necessary sops secret

```bash
export SOPS_AGE_KEY_FILE='<path-to-key.txt>'

make bootstrap0
```

2. Flux installation

```bash
export GITHUB_TOKEN='ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

make bootstrap
```

# Kubernetes Networking

## Load Balancing and Service Traffic

| Role                            | Provider                | Notes                                                                                                                                                          |
| ------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Service `LoadBalancer` provider | MetalLB                 | Allocates service external IPs from `first-pool` (`10.99.99.20-10.99.99.30`) for services such as Envoy Gateway.                                               |
| Control plane LB provider       | kube-vip                | Provides the Kubernetes API/control-plane VIP at `10.99.99.222`. kube-vip service load balancing is disabled (`svc_enable=false`).                             |
| Service traffic                 | K3s embedded kube-proxy | K3s runs kube-proxy inside the `k3s server`/`k3s agent` process, not as a Kubernetes DaemonSet. It handles ClusterIP/NodePort/service NAT using iptables mode. |
| Pod networking                  | Flannel VXLAN           | K3s built-in flannel provides pod networking via `flannel.1` and `cni0`.                                                                                       |

K3s `servicelb` (klipper-lb) is disabled, so it is not providing service LoadBalancer functionality.

# DNS Management

This homelab uses a dual ExternalDNS setup to manage both internal (homelab) and external (public) DNS records automatically from Kubernetes resources.

## Architecture

**Two ExternalDNS Instances:**

1. **external-dns (AdGuard Home)** - Internal DNS
   - **Provider**: AdGuard Home via webhook
   - **Sources**: Gateway API HTTPRoute resources
   - **Purpose**: Automatically creates A records for internal service hostnames pointing to Envoy Gateway
   - **Usage**: Internal homelab DNS resolution

2. **external-dns-cloudflare** - External DNS
   - **Provider**: Cloudflare
   - **Sources**: DNSEndpoint CRDs only
   - **Purpose**: Creates CNAME records pointing to Cloudflare Tunnel for external access
   - **Usage**: Public DNS records for services accessible outside the homelab

## How It Works

For a service to be accessible both internally and externally:

1. **Create an HTTPRoute** attached to Envoy Gateway (automatically managed by AdGuard ExternalDNS)

   ```yaml
   apiVersion: gateway.networking.k8s.io/v1
   kind: HTTPRoute
   metadata:
     name: notes
   spec:
     parentRefs:
       - name: envoy-internal
         namespace: network
     hostnames:
       - notes.${HOMELAB_DOMAIN}
     rules:
       - backendRefs:
           - name: notes
             port: 80
   ```

   → AdGuard creates an internal A record for `notes.example.com` pointing to Envoy Gateway.

2. **Create a DNSEndpoint** in `kubernetes/apps/network/external-dns-cloudflare/dnsendpoints.yaml` (managed by Cloudflare ExternalDNS)
   ```yaml
   apiVersion: externaldns.k8s.io/v1alpha1
   kind: DNSEndpoint
   metadata:
     name: homelab-notes
   spec:
     endpoints:
       - dnsName: notes.${HOMELAB_DOMAIN}
         recordType: CNAME
         targets:
           - ${CF_TUNNEL_ID}.cfargotunnel.com
   ```
   → Cloudflare creates: `notes.example.com → CNAME → tunnel`

**Result**: Same DNS name exists in both providers with different targets - internal clients use AdGuard (direct to Envoy Gateway), external clients use Cloudflare (via tunnel).

There are no Kubernetes `Ingress` resources in this cluster; routing is handled with Gateway API resources (`Gateway`, `HTTPRoute`, and `TCPRoute`) through Envoy Gateway.

# Kubernetes Backup

This homelab implements a comprehensive three-tier backup strategy covering databases, application data, and file systems.

| Type       | Primary          | Cloud         |
| ---------- | ---------------- | ------------- |
| PostgreSQL | CNPG Cluster     | Cloudflare R2 |
| Volumes    | Longhorn Volumes | Cloudflare R2 |

## Database Backups

- **Tool**: CloudNative-PG (CNPG) operator with Point-in-Time Recovery
- **Architecture**: 2-replica PostgreSQL clusters for high availability
- **Backup**: Continuous WAL archiving and base backups to Cloudflare R2
- **Recovery**: Point-in-Time Recovery (PITR) capability
- **Covers**: Immich, Movary, Fresh RSS, Vikunja, Speedtest Tracker

## Volume Backups (Longhorn)

- **Tool**: Longhorn volume snapshots and backups
- **Schedule**: Automated snapshots and backups
- **Storage**: Longhorn distributed block storage with backups to Cloudflare R2
- **Covers**: All persistent volumes including SQLite databases, application data, and configuration files

# NAS Backups

- **Tool**: Restic
- **Schedule**: Daily at 03:00 AM
- **Storage**: External HDD

### Cloud Sync

- **Tool**: Rclone → Google Drive
- **Schedule**: Every 2 days at 04:30 AM

## Requirements

- sops (secrets management)
- age (encryption)
- precommit
- flux

---

## Resources

- Proxmox Cloud init Template - https://technotim.live/posts/cloud-init-cloud-image/
