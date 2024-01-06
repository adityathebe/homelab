#!/bin/bash

# Backup
docker run --net=host \
  -v '/home/player/data/postgres-backups:/postgres-backup' \
  -e PGPASSWORD=gunners \
  --rm 'postgres:16' \
  bash -c "pg_dumpall -d 'postgres://gunners:gunners@localhost:5432/postgres' -f /postgres-backup/dumpall_\$(date +'%Y-%m-%d-%H-%M-%S').sql"
