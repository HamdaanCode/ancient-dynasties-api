// Package queries wraps the Postgres pool with typed methods that return
// domain models. Handlers call these methods and never touch the pool directly.
package queries

import (
	"errors"

	"github.com/jackc/pgx/v5/pgxpool"
)

// ErrNotFound is returned by Get* methods when the requested entity does not
// exist. Handlers translate this into HTTP 404.
var ErrNotFound = errors.New("queries: not found")

// Queries is the entry point. Construct with New(pool) and inject into the API.
type Queries struct {
	pool *pgxpool.Pool
}

// New wires a pgxpool.Pool into a Queries value.
func New(pool *pgxpool.Pool) *Queries {
	return &Queries{pool: pool}
}
