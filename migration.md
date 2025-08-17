# Storage Migration: HostPath to Longhorn

This document outlines the process for migrating application data from hostPath volumes to Longhorn-backed PVCs in a Kubernetes cluster.

## Overview

This migration strategy allows you to move persistent data from local hostPath storage to distributed Longhorn storage while minimizing downtime and ensuring data integrity.

## Prerequisites

- Longhorn storage class available in the cluster
- Applications using hostPath volumes for persistent data
- Knowledge of which node the hostPath is located on

# Phase 1

### Step 1: Scale Down Application

1. Edit the application's HelmRelease to set replicas to 0:

   ```yaml
   controllers:
     main:
       replicas: 0
   ```

### Step 2: Create Longhorn PVC

Add a new PVC to the application's `pvc.yaml` file:

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
  namespace: app-namespace
spec:
  storageClassName: longhorn
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi # Adjust size as needed
```

### Step 3: Create Migration Job

Create a migration job that runs on the same node as the hostPath:

```yaml
---
apiVersion: batch/v1
kind: Job
metadata:
  name: app-data-migration
  namespace: app-namespace
spec:
  template:
    spec:
      nodeSelector:
        kubernetes.io/hostname: target-node # Node where hostPath exists
      restartPolicy: Never
      containers:
        - name: migration
          image: alpine:latest
          command:
            - /bin/sh
            - -c
            - |
              # Install rsync
              apk add --no-cache rsync

              echo "Starting migration from hostPath to Longhorn PVC..."
              echo "Source (hostPath): $(ls -la /source/)"
              echo "Destination (Longhorn): $(ls -la /destination/)"

              # Sync all data from hostPath to Longhorn PVC with progress
              rsync -azvPh --progress /source/ /destination/

              # Verify the sync
              echo "Migration completed. Verifying..."
              echo "Source size: $(du -sh /source)"
              echo "Destination size: $(du -sh /destination)"

              # List contents for verification
              echo "Source contents:"
              find /source -type f | head -20
              echo "Destination contents:"
              find /destination -type f | head -20

              echo "Migration job completed successfully!"
          volumeMounts:
            - name: source-data
              mountPath: /source
              readOnly: true
            - name: destination-data
              mountPath: /destination
      volumes:
        - name: source-data
          hostPath:
            path: /path/to/hostpath/data # Original hostPath
            type: Directory
        - name: destination-data
          persistentVolumeClaim:
            claimName: app-data-longhorn
```

### Step 4: Add Migration Job to Kustomization

Update `kustomization.yaml`:

```yaml
resources:
  - secret.sops.yaml
  - pvc.yaml
  - helmrelease.yaml
  - migration-job.yaml # Add this temporarily
```

# Phase 2

After successful migration, update the HelmRelease to use the new Longhorn PVC:

```yaml
persistence:
  data:
    enabled: true
    existingClaim: app-data # Changed from hostPath
    advancedMounts:
      main:
        app:
          - path: /app/data
```

### Step 5: Remove Node Constraints and Scale Up\*\*

1. Remove `replicas: 0` from the HelmRelease
2. Remove `defaultPodOptions.nodeSelector` (no longer needed with Longhorn):
   ```yaml
   # Remove this entire section:
   defaultPodOptions:
     nodeSelector:
       kubernetes.io/hostname: target-node
   ```
3. Apply the configuration:
   ```bash
   kubectl apply -k path/to/app/
   ```
4. Verify the application works correctly with Longhorn storage

### Step 6: Clean Up Migration Resources

1. Remove `migration-job.yaml` from kustomization.yaml
2. Delete the migration job file
