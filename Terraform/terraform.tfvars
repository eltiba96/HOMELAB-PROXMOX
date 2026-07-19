# PROXMOX

pm_api_url          = "https://192.168.23.55:8006/api2/json"
pm_api_token_id     = "terraform@pve!terraform"
pm_api_token_secret = "TOKEN"
target_node         = "pve"
#template = "ubuntu-24-04-cloud-init-template"
# NETWORK
network_bridge = "vmbr0"

user = "leo"
# VM management SSH public key
ssh_key = "ssh-ed25519 AAAAAAA tibaleo@hotmail.it"

# VM Configurations Array
vm_configs = [
  /*{
   name        = "vm-mngmt"
    vmid        = 200        # Added vmid
    disk_size   = 10
    cores       = 16
    memory      = 8192
    description = "vm-mngmt"
   ipconfig0   = "ip=192.168.23.80/24,gw=192.168.23.254"
},*/ 
  {
    name        = "vm-master1"
    vmid        = 201
    disk_size   = 10
    cores       = 8
    memory      = 16384
    description = "vm-master1"
    ipconfig0   = "ip=192.168.23.81/24,gw=192.168.23.254"
  },
  {
    name        = "vm-worker1"
    vmid        = 203        # Added vmid
    disk_size   = 20
    cores       = 4
    memory      = 8192
    description = "vm-worker1"
    ipconfig0   = "ip=192.168.23.83/24,gw=192.168.23.254"
  },
  {
    name        = "vm-worker2"
    vmid        = 204        # Added vmid
    disk_size   = 20
    cores       = 4
    memory      = 8192
    description = "vm-worker2"
    ipconfig0   = "ip=192.168.23.84/24,gw=192.168.23.254"
  },
  {
    name        = "vm-worker3"
    vmid        = 205        # Added vmid
    disk_size   = 20
    cores       = 4
    memory      = 8192
    description = "vm-worker3"
    ipconfig0   = "ip=192.168.23.85/24,gw=192.168.23.254"
  },
  {
    name        = "vm-worker4"
    vmid        = 206        # Added vmid
    disk_size   = 20
    cores       = 4
    memory      = 8192
    description = "vm-worker4"
    ipconfig0   = "ip=192.168.23.86/24,gw=192.168.23.254"
  },
  {
    name        = "nfs-server"
    vmid        = 207        # Added vmid
    disk_size   = 100
    cores       = 4
    memory      = 8192
    description = "nfs-server"
    ipconfig0   = "ip=192.168.23.90/24,gw=192.168.23.254"
  }
]
