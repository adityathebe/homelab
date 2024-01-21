# My `Homelab`

<!-- markdownlint-disable MD033 -->

<h1 align="center">
  Homelab
</h1>

<p align="center">
  <a href="https://github.com/k8s-at-home" alt="Image used with permission from k8s-at-home"><img alt="Image used with permission from k8s-at-home" src="https://avatars.githubusercontent.com/u/61287648" /></a>
</p>

<p align="center">
  <a href="https://k3s.io/">
    <img alt="k3s" src="https://img.shields.io/badge/k3s-v1.26.9-orange?logo=kubernetes&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/WRMilling/k3s-gitops/commits/master">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/WRMilling/k3s-gitops?logo=git&logoColor=white&color=purple&style=flat-square">
  </a>
</p>

<p align="center">
Using GitOps principals and workflow to manage a lightweight <a href="https://k3s.io">k3s</a> cluster.
</p>

> In progress: My existing kubernetes manifests have secrets scattered all over them

# Infrastructure

I've used Techno Tim's [k3s-ansible](https://github.com/techno-tim/k3s-ansible) playbook to deploy a 4 node _(2 masters & 2 workers)_ cluster on 4 Proxmox VMs.

![Dashboard](https://i.imgur.com/dceiTP6.png)

## Servers

### 1. Proxmox

| Description | Spec              |
| ----------- | ----------------- |
| Server      | Acer Nitro 5      |
| RAM         | 16GB              |
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

## Requirements

- sops (secrets management)
- age (encryption)
- precommit
