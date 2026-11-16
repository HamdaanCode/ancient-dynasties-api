# ancient-dynasties-api — convenience commands
#
# Prereqs: Docker + Docker Compose, Go 1.22+ (for later phases), psql client.
#
# Database connection (local dev):
#   host=localhost port=5432 user=dynasties password=dynasties db=dynasties

DB_URL  ?= postgres://dynasties:dynasties@localhost:5432/dynasties?sslmode=disable
PSQL    := PGPASSWORD=dynasties psql -h localhost -U dynasties -d dynasties

.PHONY: help up down logs reset migrate seed db wait rulers lineage

help:
	@echo "Available targets:"
	@echo "  up         Start Postgres (docker-compose)"
	@echo "  down       Stop Postgres"
	@echo "  reset      Destroy volume + restart (clean DB)"
	@echo "  wait       Block until Postgres is accepting connections"
	@echo "  migrate    Apply the latest migration"
	@echo "  seed       Load the Mesopotamia seed data"
	@echo "  db         Open a psql shell"
	@echo "  rulers     Sanity query: list every ruler in reign order"
	@echo "  lineage    Sanity query: Sargon's successors via recursive CTE"

up:
	docker-compose up -d

down:
	docker-compose down

reset:
	docker-compose down -v
	docker-compose up -d
	$(MAKE) wait
	$(MAKE) migrate
	$(MAKE) seed

logs:
	docker-compose logs -f postgres

wait:
	@echo "Waiting for Postgres..."
	@for i in $$(seq 1 30); do \
		if $(PSQL) -c "SELECT 1" > /dev/null 2>&1; then \
			echo "Postgres ready."; exit 0; \
		fi; \
		sleep 1; \
	done; \
	echo "Timed out waiting for Postgres."; exit 1

migrate:
	$(PSQL) -f migrations/0001_initial_schema.up.sql

seed:
	$(PSQL) -f seed/mesopotamia.sql
	$(PSQL) -f seed/egypt.sql
	$(PSQL) -f seed/rome.sql
	$(PSQL) -f seed/china.sql

db:
	$(PSQL)

rulers:
	@$(PSQL) -c "\
		SELECT r.reign_start AS year, r.name, d.name AS dynasty \
		FROM rulers r JOIN dynasties d ON d.id = r.dynasty_id \
		ORDER BY r.reign_start;"

lineage:
	@$(PSQL) -c "\
		WITH RECURSIVE successors AS (\
			SELECT id, name, reign_start, successor_id, 0 AS depth \
			FROM rulers WHERE slug = 'sargon-of-akkad' \
			UNION ALL \
			SELECT r.id, r.name, r.reign_start, r.successor_id, s.depth + 1 \
			FROM rulers r JOIN successors s ON r.id = s.successor_id \
		) \
		SELECT depth, reign_start AS year, name FROM successors ORDER BY depth;"
