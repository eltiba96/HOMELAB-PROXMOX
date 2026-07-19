# homelab-PROXMOX

Personal Proxmox-based homelab. Contains the Terraform and Ansible code to provision and configure a self-managed Kubernetes cluster on Proxmox VE.

---

## Infrastructure

- **Hypervisor:** Proxmox VE at `192.168.23.55`
- **VM template:** Ubuntu 24.04 cloud-init (`ubuntu-24-04-cloud-init-template`)
- **Storage:** `local-lvm`
- **Network bridge:** `vmbr0`

---

## Repository Structure

```
homelab-PROXMOX/
├── Makefile/          # Script to build the Ubuntu 24.04 cloud-init template on Proxmox
├── Terraform/         # Provisions VMs on Proxmox via cloud-init (static IPs included)
├── Ansible/
│   ├── site.yml            # One-shot full cluster bring-up
│   ├── k8s-master-worker/  # Playbooks to install Kubernetes 1.36 (master + workers)
│   ├── firewall/           # Playbook to configure UFW (default deny)
│   └── update-apt/         # Playbook to upgrade all APT packages
├── Kubernetes/        # Raw manifests and notes for the K8s cluster
│   └── CNPG/              # CloudNative PostgreSQL cluster + backups
└── Proxmox/           # Proxmox helper scripts
```

---

## Makefile — Cloud-Init Template

Run on the Proxmox host to build the Ubuntu 24.04 cloud-init base template:

```bash
make
```

Steps performed:
1. Downloads Ubuntu 24.04 cloud image
2. Injects `qemu-guest-agent` and resets machine-id
3. Creates VM `6000` named `ubuntu-24-04-cloud-init-template`
4. Converts it to a Proxmox template

---

## Terraform — VM Provisioning

Provisions multiple VMs from the cloud-init template using a variable list.

```bash
cd Terraform
terraform init
terraform apply
```

Key variables (`variables.tf`):
- `vm_configs` — list of VMs (name, vmid, cores, memory, disk, IP)
- `pm_api_token_secret` — Proxmox API token (sensitive, not committed)
- `pm_api_url` — defaults to `https://192.168.23.55:8006/api2/json`

---

## Ansible — Kubernetes

Full cluster bring-up in one command (from the `Ansible/` directory — inventory and SSH key are set in `ansible.cfg`):

```bash
cd Ansible
ansible-playbook site.yml
```

Or run the playbooks individually:

| Playbook | Purpose |
|---|---|
| `site.yml` | Firewall → master → workers, in order |
| `k8s-master-worker/playbook-master-install-k8s.yml` | Installs the control plane (single master) + Flannel CNI |
| `k8s-master-worker/playbook-worker-install-k8s.yml` | Installs workers and joins them to the cluster automatically |
| `firewall/firewall.yml` | UFW: default deny incoming, opens K8s ports + Flannel VXLAN |
| `update-apt/playbook-apt.yml` | Runs `apt dist-upgrade` on all nodes |

Static IPs are assigned by Terraform via cloud-init (`ipconfig0`) — no separate IP-change playbook needed.

Manual installation notes (single-master variant, K8s 1.36) are in `k8s-master-worker/install-k8s-manual.txt`.

---

## Security Notes

- SSH keys live in `~/.ssh/` (referenced by `ansible.cfg`), not in this repo. The public key is injected into VMs via the `ssh_key` variable in `terraform.tfvars` (gitignored).
- Git history still contains previously committed secrets (SSH private key, kubeconfig, Proxmox API token in `terraform.tfvars`, an old kubeadm join token). Before making this repo public: revoke the Proxmox token, regenerate the SSH key pair, and scrub history with `git filter-repo`.
