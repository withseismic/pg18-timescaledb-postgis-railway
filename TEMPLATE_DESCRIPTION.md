# Deploy and Host PostgreSQL 18 + TimescaleDB + PostGIS on Railway

PostgreSQL 18 combined with TimescaleDB 2.26 and PostGIS 3.6 gives you a single database that handles relational, time-series, and geospatial workloads. Ingest time-stamped data into hypertables with automatic partitioning and compression, run spatial queries with PostGIS indexing, and use standard SQL for everything.

## About Hosting PostgreSQL 18 + TimescaleDB + PostGIS

Hosting a PostgreSQL instance with both TimescaleDB and PostGIS typically requires building a custom Docker image, managing extension compatibility across versions, and handling persistent storage with correct filesystem permissions. This template eliminates that setup entirely. It deploys PostgreSQL 18.3 with TimescaleDB 2.26.4 and PostGIS 3.6.3 pre-installed, configures a persistent volume with automatic ownership correction at container start, and includes a health check that monitors database readiness. TimescaleDB is enabled by default — PostGIS activates with a single SQL command after deployment.

## Common Use Cases

- **IoT & Sensor Data** — Ingest millions of time-stamped readings into hypertables with automatic partitioning, compression, and retention policies
- **Location-Based Services** — Spatial indexing and nearest-neighbor queries for fleet tracking, delivery routing, store locators, and city data platforms
- **Real-Time Analytics** — Continuous aggregates for dashboards and materialized rollups that refresh automatically, with time-weighted averages via TimescaleDB Toolkit
- **Financial Data** — Tick data storage, OHLCV candle generation, and percentile approximations at scale
- **Monitoring & Observability** — Metrics, logs, and traces with time-based retention and columnar compression

## Dependencies for PostgreSQL 18 + TimescaleDB + PostGIS Hosting

- **Persistent Volume** — Mounted at `/var/lib/postgresql/data` for durable storage across redeploys
- **TCP Proxy** — Enable on port `5432` in Settings → Networking for external database connections

### Deployment Dependencies

- [PostgreSQL 18 Documentation](https://www.postgresql.org/docs/18/release-18.html)
- [TimescaleDB Documentation](https://docs.timescale.com)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [timescale/timescaledb-ha Docker Image](https://hub.docker.com/r/timescale/timescaledb-ha)

### Implementation Details

After deployment, TimescaleDB is ready to use. Enable PostGIS and create your first hypertable:

```sql
-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create a time-series table with spatial data
CREATE TABLE events (
  time        TIMESTAMPTZ NOT NULL,
  device_id   TEXT NOT NULL,
  location    GEOMETRY(Point, 4326),
  payload     JSONB
);

-- Convert to a hypertable
SELECT create_hypertable('events', by_range('time'));

-- Add a spatial index
CREATE INDEX idx_events_location ON events USING GIST (location);
```

## Why Deploy PostgreSQL 18 + TimescaleDB + PostGIS on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying PostgreSQL 18 + TimescaleDB + PostGIS on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
