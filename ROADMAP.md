# Roadmap

Working checklist from Phase 1 completion through v1 shipping on AWS. Tick as you ship.

Realistic total: **12-15 hours of focused work** with Claude Code as pair programmer.

---

### 1. Push Phase 1 to GitHub ✅ when live
**~1 min**
First push to `main`. Repo stops being a secret.
Exit: `https://github.com/HamdaanCode/ancient-dynasties-api` shows all the Phase 1 files publicly.

---

### 2. Go scaffold + `/healthz` endpoint
**~30-45 min**
Create the Go module, install `chi`, serve a hello-world health endpoint at `localhost:8080/healthz`.
Exit: `curl http://localhost:8080/healthz` returns `{"status":"ok"}`.

---

### 3. Postgres connection + first real endpoint (`GET /v1/civilizations`)
**~45-60 min**
Wire up `pgx` connection pool reading from `DATABASE_URL` env var, write the first real handler that returns Mesopotamia from the DB.
Exit: `curl http://localhost:8080/v1/civilizations` returns the single Mesopotamia row as JSON.

---

### 4. Dynasty + Ruler list/detail endpoints
**~45-60 min**
`GET /v1/dynasties`, `GET /v1/dynasties/{id}`, `GET /v1/dynasties/{id}/rulers`, `GET /v1/rulers`, `GET /v1/rulers/{id}`. Plain SELECTs, nothing fancy yet.
Exit: `curl http://localhost:8080/v1/dynasties/akkadian/rulers` returns the 5 Akkadian kings.

---

### 5. ⭐ Recursive CTE endpoints — the interview showcase
**~45-60 min**
`GET /v1/rulers/{id}/ancestors` and `GET /v1/rulers/{id}/successors`. These are the SQL you demo in interviews.
Exit: `curl http://localhost:8080/v1/rulers/naram-sin/ancestors` returns a 3-generation tree walking Naram-Sin → Manishtushu → Sargon.

---

### 6. Search + event filter endpoints
**~45-60 min**
`GET /v1/search?q=sargon` (full-text search over ruler names using the `gin` tsvector index we already created), `GET /v1/events?from_year=&to_year=&civilization_id=`.
Exit: `curl "http://localhost:8080/v1/search?q=akkad"` returns Sargon + Naram-Sin + the Akkadian dynasty.

---

### 7. Integration tests with testcontainers-go
**~60-90 min**
One test file per handler. Each test spins up a real Postgres container, runs migrations + seed, hits the endpoint, asserts JSON structure.
Exit: `go test ./...` passes green locally; all endpoints have at least one integration test.

---

### 8. OpenAPI spec + Swagger UI + Dockerfile
**~60-90 min**
Hand-write `openapi.yaml`, serve the Swagger UI at `/docs`. Write a multi-stage Dockerfile for the Go binary.
Exit: `http://localhost:8080/docs` renders an interactive API browser. `docker build .` produces a working image.

---

### 9. GitHub Actions CI + AWS deployment via Terraform
**~3-4 hours**
GitHub Actions workflow: on push → `go test` → `docker build` → push to ECR → `terraform apply` → service rolls out on ECS Fargate backed by RDS Postgres. This is the biggest step; pair carefully with Claude Code.
Exit: a public AWS URL serves live API responses backed by RDS Postgres. CI goes green on push to main.

---

### 10. Egypt seed + observability + polished README
**~2-3 hours**
Add Old Kingdom + Ptolemaic rulers via a second seed file (Narmer, Khufu, Hatshepsut, Ramesses II, Cleopatra VII). Wire OpenTelemetry → CloudWatch. Write the README properly: architecture diagram (Excalidraw), schema diagram, example `curl` queries, "what I learned" note.
Exit: `curl https://your-api/v1/civilizations` returns 2 rows (Mesopotamia + Egypt). README has an architecture diagram. You can honestly send this URL to a Kaluza interviewer.

---

## Interview-ready after Step 10

You'll be able to honestly say:
> *"I built a REST API in Go, backed by Postgres, deployed on AWS via Terraform with CI/CD and OpenTelemetry observability. Two civilisations of historical data, full-text search, and recursive CTEs for monarch lineages. The repo is at github.com/HamdaanCode/ancient-dynasties-api and the live API is at [url]."*

That lands 11 of 13 common skills found across the 5-JD analysis.

---

## Cadence rules

- One step at a time, in order, no skipping
- Each step ends with a working deploy or a passing test, not uncommitted local work
- Commit at the end of each step with a message like `step 3: pgx connection + /v1/civilizations`
- If a step is taking 2x longer than estimated, stop and reassess with Claude

Ship it.
