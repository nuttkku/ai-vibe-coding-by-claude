#!/usr/bin/env bash
# Restore the production database from a dump made by backup.sh.
#   bash restore.sh backups/appdb-20260923-020000.dump
# This REPLACES the current data. The backend is stopped during the restore.
set -euo pipefail

file="${1:?usage: bash restore.sh <backup file>}"
[ -f "$file" ] || { echo "Not found: $file"; exit 1; }

set -a; . ./.env; set +a
COMPOSE="docker compose -f docker-compose.prod.yml"

read -r -p "Replace database '$POSTGRES_DB' with $file? Type yes: " answer
[ "$answer" = "yes" ] || { echo "Cancelled."; exit 1; }

$COMPOSE stop backend
$COMPOSE exec -T db pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists < "$file"
$COMPOSE start backend
echo "Restored from $file"
