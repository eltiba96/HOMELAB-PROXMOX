# Firewall

Configures UFW on every node: **default deny incoming**, with only the ports Kubernetes needs.

## Usage

```bash
# From the Ansible/ directory
ansible-playbook firewall/firewall.yml
```

## Rules applied

| Rule | Purpose |
|---|---|
| 22/tcp | SSH (allowed first — no lockout) |
| 6443/tcp | Kubernetes API server |
| 2379–2380/tcp | etcd (client + peer, on the master) |
| 10250/tcp | Kubelet API |
| 10259/tcp | kube-scheduler |
| 10257/tcp | kube-controller-manager |
| 30000–32767/tcp | NodePort services |
| 8472/udp | Flannel VXLAN (pod network between nodes) |
| from 10.244.0.0/16 | All traffic from the pod network |
| default routed: allow | Pod traffic forwarded through the node (cni0 ↔ flannel.1) |
| default incoming: deny | Everything else is blocked |
