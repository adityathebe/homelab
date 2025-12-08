#!/bin/bash

set -euo pipefail

REPO="/mnt/seagate/backups"
CANARY="$REPO/config"

source /home/admin/restic.env

# 1. Verify mount is actually active
if ! mountpoint -q /mnt/seagate; then
  echo "ERROR: /mnt/seagate is not mounted. Aborting rclone sync."
  exit 1
fi

# 2. Check repository directory exists
if [ ! -d "$REPO" ]; then
  echo "ERROR: Backup directory $REPO does not exist. Aborting."
  exit 1
fi

# 3. Run a fast restic consistency check
echo "Running restic structural check..."
if ! restic -r "$REPO" check --no-lock; then
  echo "ERROR: Restic repo failed consistency check. Aborting sync."
  exit 1
fi

# 4. Perform safe sync to B2
/var/rclone sync "$REPO" b2:nas-backup-aditya \
  --fast-list \
  --delete-during \
  -v --progress