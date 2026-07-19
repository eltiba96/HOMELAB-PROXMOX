# Kubernetes

Raw manifests, configs, and operational notes for the self-managed Kubernetes cluster running on Proxmox VMs (installed via the Ansible playbooks, currently targeting 1.36).

## Cluster topology

| Role | Host | IP |
|---|---|---|
| master | vm-master1 | 192.168.23.81 |
| worker | vm-worker1 | 192.168.23.83 |
| worker | vm-worker2 | 192.168.23.84 |
| worker | vm-worker3 | 192.168.23.85 |
| worker | vm-worker4 | 192.168.23.86 |

CNI: Flannel (`10.244.0.0/16`)

## Subfolders

| Folder | Description |
|---|---|
| `CNPG/` | CloudNative PostgreSQL cluster manifest (`pg-cluster`, 3 instances) |

## Useful commands

See `useful-commands.txt` for CNPG-specific kubectl commands (cluster status, pod roles, PVC state, logs) plus general inspection and cleanup commands.

### Label worker nodes after join

```bash
kubectl label node vm-worker1 node-role.kubernetes.io/worker=worker
kubectl label node vm-worker2 node-role.kubernetes.io/worker=worker
kubectl label node vm-worker3 node-role.kubernetes.io/worker=worker
```

### Re-generate join command

```bash
kubeadm token create --print-join-command
```
