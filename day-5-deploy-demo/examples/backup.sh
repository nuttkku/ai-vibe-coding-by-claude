#!/usr/bin/env bash
# Back up the production database to ./backups (keeps the newest 7).
# Run on the server from the folder containing docker-compose.prod.yml and .env:
#   bash backup.sh
# Optional cron (daily 02:00):  0 2 * * * cd ~/app && bash backup.sh >> backups/backup.log 2>&1
set -euo pipefail

set -a; . ./.env; set +a
COMPOSE="docker compose -f docker-compose.prod.yml"
mkdir -p backups
file="backups/${POSTGRES_DB}-$(date +%Y%m%d-%H%M%S).dump"

$COMPOSE exec -T db pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --format=custom > "$file"
echo "Backup written: $file ($(du -h "$file" | cut -f1))"

ls -1t backups/*.dump | tail -n +8 | xargs -r rm --
