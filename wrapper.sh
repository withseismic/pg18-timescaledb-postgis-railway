#!/bin/bash
set -e

if [ -n "$PGDATA" ]; then
  sudo mkdir -p "$PGDATA"
  sudo chown -R postgres:postgres "$(dirname "$PGDATA")"
fi

unset PGHOST
unset PGPORT

exec /usr/local/bin/docker-entrypoint.sh "$@"
