# My `Homelab`

> In progress: My existing kubernetes manifests have secrets scattered all over them

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
