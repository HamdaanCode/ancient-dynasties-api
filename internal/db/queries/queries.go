// Package queries wraps the Postgres pool with typed methods that return
// domain models. Handlers call these methods and never touch the pool directly.
package queries

import "github.com/jackc/pgx/v5/pgxpool"

// Queries is the entry point. Construct with New(pool) and inject into the API.
type Queries struct {
	pool *pgxpool.Pool
}

// New wires a pgxpool.Pool into a Queries value.
func New(pool *pgxpool.Pool) *Queries {
	return &Queries{pool: pool}
}
