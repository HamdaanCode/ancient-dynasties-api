package api

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/testcontainers/testcontainers-go"
	tcpg "github.com/testcontainers/testcontainers-go/modules/postgres"
	"github.com/testcontainers/testcontainers-go/wait"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

var (
	testServer *httptest.Server
	testPool   *pgxpool.Pool
)

// TestMain spins up a fresh Postgres container, applies the Phase 1 schema
// and the Mesopotamia seed, builds the API router and exposes an
// httptest.Server to the rest of the tests.
func TestMain(m *testing.M) {
	ctx := context.Background()

	container, err := tcpg.Run(
		ctx,
		"postgres:16-alpine",
		tcpg.WithDatabase("dynasties_test"),
		tcpg.WithUsername("dynasties"),
		tcpg.WithPassword("dynasties"),
		testcontainers.WithWaitStrategy(
			wait.ForLog("database system is ready to accept connections").
				WithOccurrence(2).
				WithStartupTimeout(60*time.Second),
		),
	)
	if err != nil {
		log.Fatalf("start postgres container: %v", err)
	}

	dsn, err := container.ConnectionString(ctx, "sslmode=disable")
	if err != nil {
		log.Fatalf("get connection string: %v", err)
	}

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		log.Fatalf("open pool: %v", err)
	}
	testPool = pool

	if err := runSQLFile(ctx, pool, filepath.Join("..", "..", "migrations", "0001_initial_schema.up.sql")); err != nil {
		log.Fatalf("apply migration: %v", err)
	}
	for _, seed := range []string{"mesopotamia.sql", "egypt.sql"} {
		if err := runSQLFile(ctx, pool, filepath.Join("..", "..", "seed", seed)); err != nil {
			log.Fatalf("apply seed %s: %v", seed, err)
		}
	}

	a := &API{Q: queries.New(pool)}
	testServer = httptest.NewServer(a.Router())

	code := m.Run()

	testServer.Close()
	pool.Close()
	_ = container.Terminate(ctx)

	os.Exit(code)
}

// runSQLFile reads the file at path and runs its contents as a single Exec
// against the pool. Used for migration and seed loading inside tests.
func runSQLFile(ctx context.Context, pool *pgxpool.Pool, path string) error {
	absPath, err := filepath.Abs(path)
	if err != nil {
		return fmt.Errorf("abs path %s: %w", path, err)
	}
	data, err := os.ReadFile(absPath)
	if err != nil {
		return fmt.Errorf("read %s: %w", absPath, err)
	}
	if _, err := pool.Exec(ctx, string(data)); err != nil {
		return fmt.Errorf("exec %s: %w", absPath, err)
	}
	return nil
}

// getJSON hits path on the test server, decodes the JSON body into target
// (if non-nil) and returns the response for status assertions.
func getJSON(t *testing.T, path string, target any) *http.Response {
	t.Helper()
	resp, err := http.Get(testServer.URL + path)
	if err != nil {
		t.Fatalf("GET %s: %v", path, err)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatalf("read body: %v", err)
	}
	if err := resp.Body.Close(); err != nil {
		t.Fatalf("close body: %v", err)
	}
	if target != nil {
		if err := json.Unmarshal(body, target); err != nil {
			t.Fatalf("unmarshal %s: %v (body: %s)", path, err, string(body))
		}
	}
	return resp
}
