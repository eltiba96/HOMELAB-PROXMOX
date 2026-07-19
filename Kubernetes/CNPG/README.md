# CNPG — CloudNative PostgreSQL

Manifest for a 3-instance PostgreSQL 18 cluster managed by the CloudNative PG operator.

## Cluster spec

| Setting | Value |
|---|---|
| Name | `pg-cluster` |
| Namespace | `default` |
| Instances | 3 |
| Image | `ghcr.io/cloudnative-pg/postgresql:18` |
| Storage class | `local-path` (local per-node — replication is Postgres-level) |
| Storage size | 10 Gi |
| Database | `appdb` |
| Auth | `scram-sha-256` (pg_hba) |
| Anti-affinity | enabled (`kubernetes.io/hostname`) |

## Prerequisite: local-path-provisioner

Storage is local to each node (a shared NFS volume would be a single point of failure under 3 replicas). Install the provisioner once:

```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

## Files

| File | Description |
|---|---|
| `postgres-cluster.yaml` | Main Cluster CR (includes WAL backup config) |
| `pg-superuser-secret.yaml` | Superuser credentials Secret (create locally) |
| `app-user-secret.yaml` | Application user credentials Secret (create locally) |
| `backup-credentials-secret.yaml` | S3 credentials for backups (template — fill in locally) |
| `scheduled-backup.yaml` | Daily base backup at 02:00 |
| `pg-dump-cronjob.yaml` | Daily logical pg_dump to S3 at 03:00 |
| `svc-cluster.yaml` | Extra Service for external cluster access |

## Deploy

```bash
kubectl apply -f pg-superuser-secret.yaml
kubectl apply -f app-user-secret.yaml
kubectl apply -f backup-credentials-secret.yaml   # fill in real credentials first
kubectl apply -f postgres-cluster.yaml
kubectl apply -f scheduled-backup.yaml
kubectl apply -f pg-dump-cronjob.yaml             # set the bucket name first
kubectl apply -f svc-cluster.yaml
```

## Backups

Three layers, all shipped to S3-compatible storage (Backblaze B2):

| Layer | Schedule | Protects against |
|---|---|---|
| WAL archiving | continuous | crash / point-in-time recovery |
| Base backup | 02:00 daily | full physical restore (retention 7d) |
| Logical pg_dump | 03:00 daily | logical corruption, easy cross-version restore |

Before deploying:
1. Create a bucket and an application key on Backblaze B2 (or any S3-compatible provider)
2. Set the bucket name in `postgres-cluster.yaml` (`destinationPath`) and adjust `endpointURL` if needed
3. Put the key in `backup-credentials-secret.yaml` — apply it but don't commit real values

Check backup status:

```bash
kubectl get backups
kubectl get scheduledbackup pg-cluster-daily-backup
kubectl describe cluster pg-cluster | grep -A5 "Continuous Backup"
```

## Notes

- `pg_hba` uses `scram-sha-256` — clients authenticate with username/password from the Secrets.
- `failoverDelay: 0` triggers immediate failover on primary loss.
- `NFS.txt` documents the old NFS-based storage setup — kept for reference, no longer used.
