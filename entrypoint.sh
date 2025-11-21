#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
until mysql -h"$DATABASE_HOST" -u"$DATABASE_USERNAME" -p"$DATABASE_PASSWORD" -e "SELECT 1" &> /dev/null; do
  echo "Waiting for database connection..."
  sleep 2
done

echo "Database is ready!"

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
