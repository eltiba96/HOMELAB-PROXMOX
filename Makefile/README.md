# Makefile — Ubuntu 24.04 Cloud-Init Template

Builds the Proxmox VM template that Terraform uses to clone all VMs. Run this once on the Proxmox host before running Terraform.

## Usage

```bash
# Run on the Proxmox host
make
```

## Steps

| Step | Command | Description |
|---|---|---|
| 0 | `make 0_install_tools` | Installs `libguestfs-tools` |
| 1 | `make 1_prepare_dir` | Creates `template/` working directory |
| 2 | `make 2_download_image` | Downloads Ubuntu 24.04 cloud image |
| 3 | `make 3_customize_image` | Injects `qemu-guest-agent`, resets machine-id |
| 4 | `make 4_create_vm` | Creates VM `6000` on Proxmox |
| 5 | `make 5_import_disk` | Imports the cloud image as the VM disk |
| 6 | `make 6_configure_vm` | Sets disk, boot order, serial port, guest agent |
| 7 | `make 7_resize_disk` | Resizes disk by `+5G` |
| 8 | `make 8_create_template` | Converts the VM into a reusable template |

## Result

A Proxmox template named `ubuntu-24-04-cloud-init-template` (VM ID `6000`) ready to be cloned by Terraform.

## Clean up

```bash
make 9_clean   # removes the local template/ directory
```
