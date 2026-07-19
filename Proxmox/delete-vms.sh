# Delete multiple VMs in one shot (replace with your VM IDs)
for vmid in 201 203 204 205; do
  qm stop $vmid 2>/dev/null
  qm destroy $vmid --purge
done
