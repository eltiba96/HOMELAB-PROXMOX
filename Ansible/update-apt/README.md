# update-apt

Ansible playbook to run a full APT upgrade on all Ubuntu VMs.

## Usage

```bash
# From the Ansible/ directory
ansible-playbook update-apt/playbook-apt.yml
```

## What it does

1. Refreshes the APT cache (skips if cache is less than 1 hour old)
2. Runs `apt dist-upgrade` — upgrades all packages including dependency changes
3. Removes unused packages (`autoremove`) and cleans the local cache (`autoclean`)
