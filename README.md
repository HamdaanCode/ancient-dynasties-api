# ancient-dynasties-api

A public REST API serving structured data on ancient rulers, dynasties, battles and cross-civilisation timelines.

Starting with Mesopotamia (Sumer + Akkad + Babylon), expanding to Egypt, Persia, Rome, Han China.

## Stack

- **Go** (backend)
- **PostgreSQL 16** (storage)
- **chi** (HTTP router)
- **pgx** (Postgres driver)
- **testcontainers-go** (integration tests)
- **AWS** — RDS + ECS Fargate (planned)
- **Terraform** (planned)
- **GitHub Actions** (planned)
- **OpenTelemetry** → CloudWatch (planned)

## Local dev

Requires Docker and Go 1.22+.

```bash
# Start Postgres
docker-compose up -d

# Apply migrations + seed
make migrate seed

# Run the API
make run
# ...or
go run ./cmd/api
```

API runs at `http://localhost:8080`.

## Endpoints (v1)

```
GET  /v1/civilizations
GET  /v1/civilizations/{id}
GET  /v1/dynasties
GET  /v1/dynasties/{id}
GET  /v1/dynasties/{id}/rulers
GET  /v1/rulers
GET  /v1/rulers/{id}
GET  /v1/rulers/{id}/ancestors
GET  /v1/rulers/{id}/successors
GET  /v1/events?from_year=&to_year=&civilization_id=
GET  /v1/search?q=
```

Year values use integers with BCE as negative. Sargon of Akkad (c.2334 BCE) is stored as `-2334`.

## Data

Starting Mesopotamian corpus hand-curated in `seed/mesopotamia.sql`. Further civilisations ingested via Wikidata SPARQL ETL (`scripts/etl/`).

## Status

Phase 1 of 4 in progress. See `../CV work/ancient_dynasties_api_PLAN.md` for the full roadmap.
