# Deploy PostgreSQL 18 + TimescaleDB + PostGIS

Run time-series, geospatial, and relational workloads on a single PostgreSQL 18 instance with TimescaleDB 2.26 and PostGIS 3.6 — deployed on Railway with persistent storage and health checks.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/XXXXX)

## About

This template deploys a production-ready PostgreSQL 18 database with TimescaleDB and PostGIS extensions pre-installed on Railway.com.

**PostgreSQL 18** is the latest stable release of the world's most advanced open-source relational database, featuring async I/O, incremental JSON parsing, and improved query performance.

**TimescaleDB 2.26** extends PostgreSQL with hypertables for time-series data, continuous aggregates, native compression, and the TimescaleDB Toolkit for advanced analytics — including percentile approximations, time-weighted averages, and heartbeat aggregates.

**PostGIS 3.6** adds spatial data types, spatial indexing (GiST, SP-GiST), and hundreds of geospatial functions for storing, querying, and analyzing geographic data directly in SQL.

## What's Included

| Component | Version | Description |
|-----------|---------|-------------|
| PostgreSQL | 18.3 | Latest stable release with async I/O and performance improvements |
| TimescaleDB | 2.26.4 | Hypertables, continuous aggregates, compression, columnar storage |
| TimescaleDB Toolkit | 1.22.0 | Percentile approximations, time-weighted averages, heartbeat aggregates |
| PostGIS | 3.6.3 | Spatial types, GiST indexing, geometry/geography functions |
| GEOS | 3.10.2 | Geometry engine for spatial operations |
| PROJ | 8.2.1 | Coordinate transformation library |

## Use Cases

- **IoT & Sensor Data** — Ingest millions of time-stamped readings with hypertable partitioning and compression
- **Real-Time Analytics** — Continuous aggregates for dashboards, rollups, and materialized views that refresh automatically
- **Location Services** — Spatial indexing and nearest-neighbor queries for fleet tracking, delivery routing, and store locators
- **City Data Platforms** — Transit, demographics, crime, POIs, and pedestrian flow with geospatial joins
- **Financial Data** — Tick data, OHLCV candles, and time-weighted averages with TimescaleDB Toolkit
- **Monitoring & Observability** — Metrics, logs, and traces with time-based retention policies and compression

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | `postgres` | Database superuser name |
| `POSTGRES_PASSWORD` | — | **Required.** Superuser password |
| `POSTGRES_DB` | `postgres` | Default database created on first boot |
| `PGDATA` | `/var/lib/postgresql/data/pgdata` | Data directory inside the volume mount |

### Auto-Generated Variables

Railway automatically provides these after deployment:

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | Public connection string (available after enabling TCP Proxy) |
| `DATABASE_PRIVATE_URL` | Internal connection string for service-to-service communication |

## Quick Start

### 1. Deploy

Click the **Deploy on Railway** button above or use the Railway CLI:

```bash
railway deploy --template pg18-timescaledb-postgis
```

### 2. Enable External Access

Go to **Settings → Networking → TCP Proxy** and enable it on port `5432`. This gives you an external host and port for connecting from your local machine, ORMs, and GUI tools.

### 3. Connect & Enable PostGIS

TimescaleDB is enabled by default. PostGIS is installed but needs to be activated:

```sql
-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Verify all extensions
SELECT extname, extversion FROM pg_extension ORDER BY extname;
```

### 4. Create Your First Hypertable

```sql
-- Create a time-series table
CREATE TABLE sensor_readings (
  time        TIMESTAMPTZ NOT NULL,
  sensor_id   TEXT NOT NULL,
  location    GEOMETRY(Point, 4326),
  temperature DOUBLE PRECISION,
  humidity    DOUBLE PRECISION
);

-- Convert to a TimescaleDB hypertable
SELECT create_hypertable('sensor_readings', by_range('time'));

-- Add a spatial index
CREATE INDEX idx_sensor_location ON sensor_readings USING GIST (location);

-- Enable compression (optional)
ALTER TABLE sensor_readings SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'sensor_id'
);
```

## How It Works

Railway mounts volumes as root-owned filesystems. PostgreSQL requires its data directory to be owned by the `postgres` user. The included `wrapper.sh` resolves this by fixing volume ownership at container start before delegating to the upstream PostgreSQL entrypoint — the same approach used by official Railway database templates.

### Health Check

The container includes a built-in health check using `pg_isready` that verifies PostgreSQL is accepting connections. Railway uses this to determine service health and trigger restarts if needed.

## Configuration

### Connecting from Your Application

Use `DATABASE_PRIVATE_URL` for services running on Railway (faster, no egress costs):

```
postgresql://postgres:<password>@timescaledb-postgis.railway.internal:5432/<dbname>
```

Use `DATABASE_URL` for external connections (requires TCP Proxy enabled):

```
postgresql://postgres:<password>@<proxy-host>:<proxy-port>/<dbname>
```

### Recommended Client Libraries

| Language | Library |
|----------|---------|
| Node.js | `postgres` (postgres.js) or `pg` |
| Python | `psycopg2` or `asyncpg` |
| Go | `pgx` |
| Rust | `sqlx` or `tokio-postgres` |

## Base Image

Built on [`timescale/timescaledb-ha:pg18-ts2.26-all`](https://hub.docker.com/r/timescale/timescaledb-ha), the official TimescaleDB High Availability image which includes the full PostgreSQL extension suite.

## Links

- [PostgreSQL 18 Release Notes](https://www.postgresql.org/docs/18/release-18.html)
- [TimescaleDB Documentation](https://docs.timescale.com)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [Railway Documentation](https://docs.railway.com)

## License

MIT
