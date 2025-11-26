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

I've used Techno Tim's [k3s-ansible](https://github.com/techno-tim/k3s-ansible) playbook to deploy a 6 node _(3 masters & 3 workers)_ cluster across 3 Proxmox hosts, with each host running 2 VMs (1 master node with 4GB RAM/2vCPU and 1 worker node with 8GB RAM/4vCPU).

![Dashboard](.github/images/homepage.png)

## Servers

### 1. Proxmox Cluster

| Hostname | Model            | CPU        | RAM  | Storage        | Proxmox |
| -------- | ---------------- | ---------- | ---- | -------------- | ------- |
| cazorla  | Beelink S12 Pro  | Intel N100 | 16GB | 512GB SATA SSD | 8.4     |
| ramsey   | Beelink MINI-S13 | Intel N150 | 16GB | 512GB NVMe     | 9.1     |
| wilshere | Beelink EQ14     | Intel N150 | 16GB | 500GB NVMe     | 8.4     |

Each Proxmox host runs:

- 1x Kubernetes master node (4GB RAM, 2vCPU)
- 1x Kubernetes worker node (8GB RAM, 4vCPU)

### 2. TrueNAS Scale

| Description | Spec                           |
| ----------- | ------------------------------ |
| Server      | SONY VAIO - SVE14126CXB (2012) |
| RAM         | 8GB _(maxed out)_              |
| CPU         | Intel i5-3210M                 |
| SSD (os)    | 128GB                          |
| SDD         | 1TB                            |

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

# DNS Management

This homelab uses a dual ExternalDNS setup to manage both internal (homelab) and external (public) DNS records automatically from Kubernetes resources.

## Architecture

**Two ExternalDNS Instances:**

1. **external-dns (AdGuard Home)** - Internal DNS

   - **Provider**: AdGuard Home via webhook
   - **Sources**: Ingress resources
   - **Purpose**: Automatically creates A records pointing to nginx-ingress (`10.99.99.25`) for all services
   - **Usage**: Internal homelab DNS resolution

2. **external-dns-cloudflare** - External DNS
   - **Provider**: Cloudflare
   - **Sources**: DNSEndpoint CRDs only
   - **Purpose**: Creates CNAME records pointing to Cloudflare Tunnel for external access
   - **Usage**: Public DNS records for services accessible outside the homelab

## How It Works

For a service to be accessible both internally and externally:

1. **Create an Ingress** (automatically managed by AdGuard ExternalDNS)

   ```yaml
   ingress:
     enabled: true
     className: nginx
     hosts:
       - host: "notes.${HOMELAB_DOMAIN}"
   ```

   → AdGuard creates: `notes.example.com → A → 10.99.99.25`

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

**Result**: Same DNS name exists in both providers with different targets - internal clients use AdGuard (direct to ingress), external clients use Cloudflare (via tunnel).

# Kubernetes Backup

This homelab implements a comprehensive three-tier backup strategy covering databases, application data, and file systems.

| Type       | Primary          | Cloud         |
| ---------- | ---------------- | ------------- |
| PostgreSQL | CNPG Cluster     | Cloudflare R2 |
| Volumes    | Longhorn Volumes | Cloudflare R2 |

## Database Backups

- **Tool**: CloudNative-PG (CNPG) operator with Point-in-Time Recovery
- **Architecture**: 3-replica PostgreSQL cluster for high availability
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
- **Retention**: 90 days local
- **Storage**: External HDD (`/home/admin/seagate/backups`)

### Cloud Sync

- **Tool**: Rclone → Backblaze B2
- **Schedule**: Every 2 days at 04:30 AM
- **Sources**: Personal files (`/mnt/mega/aditya`), Photos (`/mnt/mega/photos`)

## Recovery

All backup credentials are encrypted with SOPS/Age and managed through GitOps. Recovery procedures involve:

1. Database restores from CNPG Point-in-Time Recovery or replica promotion
2. Volume restores from Longhorn snapshots and backups
3. File system restores using `restic restore` from local or cloud repositories
4. Application data persistence through Longhorn distributed storage

## Requirements

- sops (secrets management)
- age (encryption)
- precommit

---

## Resources

- Proxmox Cloud init Template - https://technotim.live/posts/cloud-init-cloud-image/
