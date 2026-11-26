#!/usr/bin/env bash
set -euo pipefail
umask 077

STAMP="$(date +%F-%H%M)"
DEST="/backups"
APP_ARCHIVE="${DEST}/wordpress-${STAMP}.tar.gz"
DB_ARCHIVE="${DEST}/wordpress-${STAMP}.sql.gz"
MIN_BYTES=1024
REMOTE_TARGET="vagrant@192.168.56.20:/backups/"
SSH_KEY="/root/.ssh/backup"

mkdir -p "$DEST" && chmod 700 "$DEST"

tar -C /srv/www -czf "$APP_ARCHIVE" wordpress
mysqldump --single-transaction wordpress | gzip > "$DB_ARCHIVE"

for f in "$APP_ARCHIVE" "$DB_ARCHIVE"; do
  if [ ! -s "$f" ] || [ "$(stat -c%s "$f")" -lt "$MIN_BYTES" ]; then
    echo "$(date '+%F %T') ERROR: backup file missing or too small: $f" >&2
    exit 1
  fi
done

find "$DEST" -type f \( -name "wordpress-*.tar.gz" -o -name "wordpress-*.sql.gz" \) -mtime +7 -delete

rsync -az -e "ssh -i $SSH_KEY" "$APP_ARCHIVE" "$DB_ARCHIVE" "$REMOTE_TARGET"

echo "$(date '+%F %T') OK: backup completed stamp=${STAMP} files=$(basename "$APP_ARCHIVE"),$(basename "$DB_ARCHIVE")"