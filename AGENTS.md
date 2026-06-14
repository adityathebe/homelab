## Canonical Project Information

Read `Readme.md` for current project overview, infrastructure, storage, networking/DNS, backups, setup, and requirements.

## Project Structure

### `/kubernetes/` - GitOps Configuration

- `apps/` - Application deployments organized by namespace (cert-manager, default, media, monitoring, etc.)
- `base/` - Base configurations, Helm repositories, namespaces, cluster variables
- `bootstrap/` - FluxCD bootstrap configuration

### `/terraform/` - Infrastructure as Code

- `cloudflare/` - DNS management and Cloudflare tunnel configurations
- `aws/` - S3 backend for Terraform state management

### `/ansible/` - Server Configuration

- Server provisioning configuration

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

## Commands

- use `kubectl cnpg ` command to work with CNPG cluster

## Talk to vms and k8s nodes

You can run commands on the proxmox hosts, and the vms running on them using ssh <hostname>,

Available hosts

Proxmox hosts

- cazorla
  - vm: wrighty(k8s master)
  - vm: alexis (k8s worker)
- wilshere
  - vm: saliba (k8s worker)
  - vm: arteta (k8s master)
- jhapa (bare metal k8s worker)

## References

Some homelab repos are present in ~/projects/homeops-repos/
You can use them as a reference
