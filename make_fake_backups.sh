#!/usr/bin/env bash
DEST="${HOME}/backups"
mkdir -p "$DEST"
# generate some fake backups with different dates
for d in 0 1 2 3 4 5 6 7 10 15 30 60 90; do
  ts=$(date -d "-${d} days" +"%Y-%m-%d-0900" 2>/dev/null || date -v-"${d}d" +"%Y-%m-%d-0900" 2>/dev/null)
  name="backup-${ts}.tar.gz"
  touch "$DEST/$name"
  echo "fake" > "$DEST/$name.sha256"
done
echo "Created fake backups in $DEST"
