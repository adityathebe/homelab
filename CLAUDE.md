# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a GitOps-managed homelab infrastructure running a 6-node K3s cluster (3 masters, 3 workers) across 3 Proxmox hosts.
The entire infrastructure is declaratively managed through FluxCD, with secrets encrypted using SOPS/Age.

## Architecture

- **K3s Kubernetes cluster** v1.30.2 orchestrating 40+ self-hosted applications
- **FluxCD** for GitOps continuous deployment
- **Terraform** for infrastructure as code (Cloudflare DNS, AWS S3 backend)
- **Ansible** for server provisioning (k3s-ansible playbook)
- **SOPS + Age** for encrypted secrets management

## Project Structure

### `/kubernetes/` - GitOps Configuration

- `apps/` - Application deployments organized by namespace (cert-manager, default, media, monitoring, etc.)
- `base/` - Base configurations, Helm repositories, namespaces, cluster variables
- `bootstrap/` - FluxCD bootstrap configuration

### `/terraform/` - Infrastructure as Code

- `cloudflare/` - DNS management and Cloudflare tunnel configurations
- `aws/` - S3 backend for Terraform state management

### `/ansible/` - Server Configuration

- Server provisioning and k3s cluster setup using techno-tim's k3s-ansible

## Development Patterns

### Adding New Applications

1. Create namespace in `kubernetes/base/namespaces/`
2. Add Helm repository if needed in `kubernetes/base/helmrepositories/`
3. Create application directory under appropriate namespace in `kubernetes/apps/`
4. Use this structure:
   ```
   kubernetes/apps/<namespace>/<app>/
   ├── helmrelease.yaml    # or deployment.yaml for custom manifests
   ├── kustomization.yaml
   ├── secret.sops.yaml    # encrypted secrets
   └── pvc.yaml           # if persistent storage needed
   ```
5. Reference in `kubernetes/base/kustomizations/<namespace>/`

### Secret Management

- All secrets MUST be encrypted with SOPS before committing
- Use `.sops.yaml` extension for encrypted files
- Never commit unencrypted secrets
- Environment variables: `SOPS_AGE_KEY_FILE` and `GITHUB_TOKEN` required

### Storage Patterns

- **Longhorn**: Distributed block storage with volume snapshots and backups to Cloudflare R2
- **NFS storage class**: For shared persistent volumes across nodes

### Database Patterns

- **CNPG**: CloudNative-PG operator for PostgreSQL clusters with 3 replicas and PITR backups to Cloudflare R2

## Infrastructure Details

**Hardware**: 3 Beelink mini PCs (S12 Pro with N100, S13 with N150, EQ14 with N150) running Proxmox

- Each Proxmox host runs 1 master node (4GB RAM, 2vCPU) and 1 worker node (8GB RAM, 4vCPU)

**Storage**: TrueNAS Scale on Sony VAIO (8GB RAM, Intel i5-3210M) providing NFS and SMB
**Network**: Cloudflare tunnels for external access, nginx-ingress for internal routing
