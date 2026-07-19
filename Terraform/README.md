# Terraform — VM Provisioning

Provisions multiple Ubuntu 24.04 VMs on Proxmox using cloud-init. All VMs are cloned from a pre-built template.

## Prerequisites

- Proxmox API token with VM creation rights (see below)
- Cloud-init template already built (see `../Makefile/`)

### Create a least-privilege Terraform user (one-time, on the Proxmox host)

Don't use `root@pam` — create a dedicated user with only the permissions Terraform needs:

```bash
pveum user add terraform@pve
pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AuditSpace Datastore.AllocateSpace SDN.Use"
pveum aclmod / -user terraform@pve -role TerraformProv
pveum user token add terraform@pve terraform -privsep=0
```

The last command prints the token secret — store it in `terraform.tfvars` (never commit it).

## Configuration

| Variable | Default | Description |
|---|---|---|
| `pm_api_url` | `https://192.168.23.55:8006/api2/json` | Proxmox API endpoint |
| `pm_api_token_id` | `terraform@pve!terraform` | Proxmox token ID |
| `pm_api_token_secret` | — | Proxmox token secret (sensitive) |
| `target_node` | `pve` | Proxmox node name |
| `template` | `ubuntu-24-04-cloud-init-template` | Source template to clone |
| `local_storage` | `local-lvm` | Proxmox storage for VM disks |
| `network_bridge` | `vmbr0` | Network bridge |

## Usage

```bash
terraform init
terraform apply -var="pm_api_token_secret=<TOKEN>" -var="user=<USER>" -var="ssh_key=<PUBKEY>"
```

Or create a `terraform.tfvars` file with the sensitive values (do not commit it).

## Output

After apply, `vm_ips` prints the IP address of each provisioned VM.

## Files

| File | Purpose |
|---|---|
| `provider.tf` | Proxmox provider configuration (telmate/proxmox v3.0.2-rc03) |
| `main.tf` | VM resource definition using cloud-init |
| `variables.tf` | Input variable declarations |
| `output.tf` | Outputs VM IP addresses |
