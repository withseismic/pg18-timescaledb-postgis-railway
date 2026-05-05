# PostgreSQL 18 + TimescaleDB + PostGIS on Railway

One-click deploy of PostgreSQL 18 with TimescaleDB 2.26 and PostGIS on Railway, with persistent storage and SSL-ready.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/XXXXX)

## What's Included

- **PostgreSQL 18.3** — Latest stable release
- **TimescaleDB 2.26** — Time-series hypertables, continuous aggregates, compression
- **PostGIS** — Spatial queries, geometry types, GIS functions
- **Persistent volume** — Data survives redeploys
- **TCP Proxy** — External connections via `psql`, ORMs, GUI tools

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `postgres` | Database superuser |
| `POSTGRES_PASSWORD` | *required* | Superuser password |
| `POSTGRES_DB` | `postgres` | Default database name |
| `PGDATA` | `/var/lib/postgresql/data/pgdata` | Data directory (inside volume mount) |

## Quick Start

After deploying, enable **TCP Proxy** on port `5432` in Settings > Networking to connect externally.

```bash
# Connect
psql "$DATABASE_URL"

# Enable extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS timescaledb;

# Verify
SELECT postgis_full_version();
SELECT extversion FROM pg_extension WHERE extname = 'timescaledb';
```

## How It Works

Railway mounts volumes as root, but PostgreSQL runs as the `postgres` user. The included `wrapper.sh` fixes volume ownership at container start before delegating to the upstream entrypoint — the same approach used by official Railway database templates.

## Use Cases

- IoT and sensor data with time-series + geospatial queries
- Real-time analytics dashboards with hypertables
- Location-based services with spatial indexing
- City data platforms (transit, demographics, POIs)
- Fleet tracking and logistics

## Base Image

Built on [`timescale/timescaledb-ha:pg18-ts2.26-all`](https://hub.docker.com/r/timescale/timescaledb-ha) which includes the full extension suite from the TimescaleDB HA image.
