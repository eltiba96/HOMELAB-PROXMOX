# Ansible

Ansible playbooks for post-provisioning configuration of the Kubernetes cluster VMs.

## Quick start

Run everything (firewall → master → workers) from this directory:

```bash
ansible-playbook site.yml
```

`ansible.cfg` already sets the inventory (`inventory.ini`) and the SSH private key — no `-i` needed when running from this directory.

## Subfolders

| Folder | Purpose |
|---|---|
| `k8s-master-worker/` | Playbooks to install Kubernetes 1.36: control plane (single master) + workers |
| `firewall/` | UFW playbook: default deny incoming, opens K8s ports + Flannel VXLAN |
| `update-apt/` | Playbook to upgrade all APT packages |

## Requirements

```bash
pip install ansible
ansible-galaxy collection install community.general
```

## Inventory

The shared inventory is `inventory.ini` in this directory: 1 master, 4 workers.
