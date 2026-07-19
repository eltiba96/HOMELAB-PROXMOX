# Proxmox

Helper scripts for day-to-day Proxmox VE management. Run these directly on the Proxmox host.

## Scripts

### Delete multiple VMs — `delete-vms.sh`

Stops and destroys a list of VMs in one shot. Edit the `vmid` list before running.

```bash
for vmid in 201 203 204 205; do
  qm stop $vmid 2>/dev/null
  qm destroy $vmid --purge
done
```

## Auto-start VMs on boot

Proxmox supports this natively — no script needed:

```bash
qm set <vmid> --onboot 1
```

Or per VM in the GUI: Options → Start at boot.
