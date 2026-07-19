# k8s-master-worker

Ansible playbooks to install a Kubernetes 1.36 cluster with containerd on Ubuntu VMs: a single control-plane node plus workers. The version is set once in the `kubernetes_version` var at the top of each playbook — APT repo, package pins, and crictl all follow it.

## Architecture

- 1 master (`vm-master1`) — control plane, API server on its own IP
- Workers join the master via a fresh `kubeadm token`

## Usage

```bash
# From the Ansible/ directory

# 1. Install the control plane (kubeadm init on master1)
ansible-playbook k8s-master-worker/playbook-master-install-k8s.yml

# 2. Install workers — the join command is generated on the master automatically
ansible-playbook k8s-master-worker/playbook-worker-install-k8s.yml

# 3. Label the workers (run on the master)
kubectl label node vm-worker1 node-role.kubernetes.io/worker=worker
```

To allow workload pods on the master:

```bash
ansible-playbook k8s-master-worker/playbook-master-install-k8s.yml -e allow_pods_on_master=true
```

## How the master playbook works

| Play | Hosts | What it does |
|---|---|---|
| 1 | vm-master | Prerequisites: swap off, kernel modules, sysctl, containerd, kubeadm/kubelet/kubectl |
| 2 | vm-master1 | `kubeadm init`, kubeconfig copy, Flannel |

## Files

| File | Description |
|---|---|
| `playbook-master-install-k8s.yml` | Control plane install (2 plays, see above) |
| `playbook-worker-install-k8s.yml` | Full worker install + automatic cluster join |
| `install-k8s-manual.txt` | Manual walkthrough (reference) |
| `label-workers.txt` | Post-join worker labeling commands |
