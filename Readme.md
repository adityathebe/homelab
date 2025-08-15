<h1 align="center">
  Homelab
</h1>

<p align="center">
  <a href="https://github.com/k8s-at-home" alt="Image used with permission from k8s-at-home"><img alt="Image used with permission from k8s-at-home" src="https://avatars.githubusercontent.com/u/61287648" /></a>
</p>

<p align="center">
  <a href="https://k3s.io/">
    <img alt="k3s" src="https://img.shields.io/badge/k3s-v1.30.2-orange?logo=kubernetes&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/adityathebe/homelab/commits/master">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/adityathebe/homelab?logo=git&logoColor=white&color=purple&style=flat-square">
  </a>
</p>

<p align="center">
Using GitOps principals and workflow to manage a lightweight <a href="https://k3s.io">k3s</a> cluster.
</p>

# Infrastructure

I've used Techno Tim's [k3s-ansible](https://github.com/techno-tim/k3s-ansible) playbook to deploy a 3 node _(1 master & 2 workers)_ cluster on 3 Proxmox VMs.

![Dashboard](https://i.imgur.com/dceiTP6.png)

## Servers

### 1. Proxmox

| Description | Spec              |
| ----------- | ----------------- |
| Server      | Acer Nitro 5      |
| RAM         | 32GB              |
| CPU         | Intel i7 11th gen |
| HDD         | 1TB               |
| SSD         | 256GB             |

### 2. TrueNAS Scale

| Description | Spec                           |
| ----------- | ------------------------------ |
| Server      | SONY VAIO - SVE14126CXB (2012) |
| RAM         | 8GB _(maxed out)_              |
| CPU         | Intel i5-3210M                 |
| SSD (os)    | 256GB                          |
| SDD         | 1TB                            |

![Server](https://i.imgur.com/NZUvI2A.jpg)
_Proxmox & Truenas(bottom) servers_

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

# Backup Strategy

This homelab implements a comprehensive three-tier backup strategy covering databases, application data, and file systems.

## Database Backups

### PostgreSQL (Daily Dumps)

- **Tool**: `prodrigestivill/postgres-backup-local:17` via Kubernetes CronJob
- **Schedule**: Daily at midnight
- **Retention**: 60 days daily, 8 weeks weekly, 6 months monthly
- **Storage**: 50GB NFS persistent volume
- **Covers**: Immich, Movary, Fresh RSS, Vikunja, Mealie, Speedtest Tracker

### SQLite (Real-time Replication)

- **Tool**: Litestream → Cloudflare R2
- **Schedule**: Real-time continuous replication
- **Covers**: Navidrome, Jellyfin, Jellyseerr, Sonarr, Radarr, Prowlarr, Actual Budget

## File System Backups

### Local & External Storage

- **Tool**: Restic
- **Schedule**: Daily at 03:00 AM
- **Retention**: 90 days local
- **Storage**: External HDD (`/home/admin/seagate/backups`)

### Cloud Sync

- **Tool**: Rclone → Backblaze B2
- **Schedule**: Every 2 days at 04:30 AM
- **Sources**: Personal files (`/mnt/mega/aditya`), Photos (`/mnt/mega/photos`)

## Backup Locations

| Type        | Primary      | Secondary    | Cloud         |
| ----------- | ------------ | ------------ | ------------- |
| PostgreSQL  | NFS Storage  | -            | -             |
| SQLite      | Local SQLite | -            | Cloudflare R2 |
| File System | TrueNAS      | External HDD | Backblaze B2  |

## Recovery

All backup credentials are encrypted with SOPS/Age and managed through GitOps. Recovery procedures involve:

1. Database restores from daily dumps or real-time replicas
2. File system restores using `restic restore` from local or cloud repositories
3. Application data persistence through NFS storage class

## Requirements

- sops (secrets management)
- age (encryption)
- precommit
