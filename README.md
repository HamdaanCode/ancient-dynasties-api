# ancient-dynasties-api

[![ci](https://github.com/HamdaanCode/ancient-dynasties-api/actions/workflows/ci.yml/badge.svg)](https://github.com/HamdaanCode/ancient-dynasties-api/actions/workflows/ci.yml)

A public REST API serving structured data on ancient rulers, dynasties and events across world civilisations. Built in Go with Postgres, Docker and OpenAPI, deployed through GitHub Actions CI.

Currently seeded with **Mesopotamia** (Sumer / Akkad / Babylon / Neo-Babylon) and **Ancient Egypt** (Old Kingdom through Ptolemaic). Designed so additional civilisations are a seed-file drop-in, no code changes.

## What this is (and what it is for)

Most grad portfolio projects are a todo list or a weather app. This one is a backend service with:

- A meaningful relational schema (civilisations → dynasties → rulers → events, plus places)
- Recursive SQL for lineage queries (walk Naram-Sin's ancestors back three generations with one query)
- Full-text search backed by a Postgres `gin` index
- 22+ integration tests running real Postgres per-run via testcontainers
- A 20.7MB distroless Docker image built in a multi-stage Dockerfile
- CI on every push to main
- An OpenAPI 3.1 spec served at `/openapi.yaml` with a Swagger UI at `/docs`

Built as a learning project to go deeper than frontend-with-Python-side-scripts into real backend work: Go, Postgres schema design, recursive CTEs, cloud-ready Docker, infrastructure as code.

## Quick start

Requires Docker and Go 1.26+.

```bash
# 1. Start Postgres
docker compose up -d

# 2. Apply the schema and seed both civilisations
make migrate seed

# 3. Build and run the API
go build -o bin/api ./cmd/api
./bin/api
```

Hit it:

```bash
curl http://localhost:8080/v1/civilizations | jq
```

Or open [http://localhost:8080/docs](http://localhost:8080/docs) in a browser for the interactive Swagger UI.

## The endpoints that matter

### Civilisations, dynasties, rulers

```
GET /v1/civilizations
GET /v1/dynasties                         # filter with ?civilization=egypt
GET /v1/dynasties/{slug}                  # e.g. akkadian, ptolemaic
GET /v1/dynasties/{slug}/rulers
GET /v1/rulers                            # filter with ?civilization= or ?dynasty=
GET /v1/rulers/{slug}                     # e.g. sargon-of-akkad, cleopatra-vii
```

### Lineage via recursive CTE

```
GET /v1/rulers/{slug}/ancestors           # walks father_id back
GET /v1/rulers/{slug}/successors          # walks successor_id forward
```

Example:

```bash
curl http://localhost:8080/v1/rulers/naram-sin/ancestors | jq '.[] | "\(.depth) \(.name)"'
# "0 Naram-Sin of Akkad"
# "1 Manishtushu"
# "2 Sargon of Akkad"
```

The SQL under this is a single recursive CTE joining to rulers, dynasties and civilisations to return the full embedded response shape in one trip.

### Search and events

```
GET /v1/search?q=akkad                    # rulers + dynasties (name + description)
GET /v1/events?from_year=-700&to_year=-500
```

Events uses integer years with BCE encoded as negative (Sargon of Akkad is `-2334`, Cleopatra is `-30`).

## Schema

Seven tables, hand-designed for the problem rather than inherited from an ORM.

```
civilizations                   top-level grouping
├── dynasties                   many per civilization
│   └── rulers                  many per dynasty
│       ├── father_id           self-ref for lineage CTE
│       ├── mother_id           self-ref
│       ├── predecessor_id      self-ref for succession CTE
│       └── successor_id        self-ref
events                          historical events (battles, treaties, deaths, founding)
places                          ancient cities and sites with coordinates
rulers_events                   many-to-many join (role: victor | defeated | signatory | …)
rulers_places                   many-to-many join (context: capital | pyramid site | buried | …)
```

Full schema in [`migrations/0001_initial_schema.up.sql`](migrations/0001_initial_schema.up.sql).

## Stack

- **Go 1.26**, [`chi/v5`](https://github.com/go-chi/chi) for routing, [`pgx/v5`](https://github.com/jackc/pgx) for Postgres
- **Postgres 16** (alpine) with a `gin` tsvector index powering search and recursive CTEs for lineage
- **OpenAPI 3.1** spec embedded into the binary at build time, served with Swagger UI from a CDN
- **Multi-stage Dockerfile** producing a `gcr.io/distroless/static-debian12:nonroot` image (final size 20.7MB)
- **testcontainers-go** spins up a fresh Postgres container per test run for real integration tests, no mocks
- **GitHub Actions** runs `go vet`, the full test suite and `docker build` on every push to main
- Planned: AWS deployment via Terraform (RDS + ECS Fargate), OpenTelemetry → CloudWatch

## Repository layout

```
.github/workflows/ci.yml        GitHub Actions: tests + docker build
cmd/api/main.go                 wires env → DB pool → API router → http server
internal/
├── api/                        http handlers + router + swagger ui + openapi spec
├── db/                         pgx pool + queries (one file per entity)
├── models/                     plain structs for domain + API response shapes
docker-compose.yml              local Postgres for dev
Dockerfile                      multi-stage static build
Makefile                        convenience targets (up / down / migrate / seed / rulers / lineage)
migrations/                     numbered up/down SQL migrations
seed/
├── mesopotamia.sql             16 rulers across 4 dynasties
└── egypt.sql                   15 rulers across 4 dynasties
ROADMAP.md                      step-by-step plan from scratch to v1
```

## Testing

```bash
go test ./...
```

testcontainers-go spins up a Postgres container, applies the schema and both seed files, then hits every endpoint through an `httptest.Server`. Covers 404 paths, filter combinations, recursive CTE lineage walks and search behaviour.

## Current status

v1 shipped: both civilisations, every endpoint, CI green on every push, Docker image ready to deploy.

Next:
- AWS deploy via Terraform (RDS + ECS Fargate + ALB)
- OpenTelemetry → CloudWatch wiring
- Han China, Rome and Persia seed files

## Attribution

Historical dates follow conventional middle-chronology for Mesopotamia and conventional chronology for Egypt. Transliterations are the common academic forms. Data is hand-curated from standard references, not scraped.

## Author

[@HamdaanCode](https://github.com/HamdaanCode) — built as a portfolio piece demonstrating real backend engineering practices (Go + Postgres + Docker + CI) rather than another CRUD clone.
