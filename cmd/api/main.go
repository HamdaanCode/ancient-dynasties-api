package main

import (
	"context"
	"log"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/api"
	"github.com/HamdaanCode/ancient-dynasties-api/internal/db"
	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	dsn := envOr("DATABASE_URL", "postgres://dynasties:dynasties@localhost:5432/dynasties?sslmode=disable")
	pool, err := db.NewPool(ctx, dsn)
	if err != nil {
		log.Fatalf("db pool: %v", err)
	}
	defer pool.Close()
	log.Printf("connected to %s", redactDSN(dsn))

	a := &api.API{Q: queries.New(pool)}

	addr := ":" + envOr("PORT", "8080")
	srv := &http.Server{
		Addr:              addr,
		Handler:           a.Router(),
		ReadHeaderTimeout: 5 * time.Second,
	}

	go func() {
		log.Printf("ancient-dynasties-api listening on %s", addr)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("server exited: %v", err)
		}
	}()

	<-ctx.Done()
	log.Printf("shutdown signal received")
	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		log.Printf("graceful shutdown failed: %v", err)
	}
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

// redactDSN hides the password in a postgres DSN before logging it.
func redactDSN(dsn string) string {
	u, err := url.Parse(dsn)
	if err != nil {
		return "<unparseable DSN>"
	}
	if _, hasPass := u.User.Password(); hasPass {
		u.User = url.UserPassword(u.User.Username(), "***")
	}
	return u.String()
}
