// Package api builds the HTTP router and holds the handler dependencies.
package api

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

// API is the handler group. Keep it small, add more deps here as we grow.
type API struct {
	Q *queries.Queries
}

// Router wires chi middleware and every route this service exposes.
func (a *API) Router() http.Handler {
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Timeout(10 * time.Second))

	r.Get("/healthz", healthz)
	r.Get("/openapi.yaml", a.serveOpenAPISpec)
	r.Get("/docs", a.serveDocs)

	r.Route("/v1", func(r chi.Router) {
		r.Get("/civilizations", a.listCivilizations)

		r.Route("/dynasties", func(r chi.Router) {
			r.Get("/", a.listDynasties)
			r.Get("/{slug}", a.getDynasty)
			r.Get("/{slug}/rulers", a.listDynastyRulers)
		})

		r.Route("/rulers", func(r chi.Router) {
			r.Get("/", a.listRulers)
			r.Get("/{slug}", a.getRuler)
			r.Get("/{slug}/ancestors", a.getAncestors)
			r.Get("/{slug}/successors", a.getSuccessors)
		})

		r.Get("/events", a.listEvents)
		r.Get("/search", a.searchHandler)
	})

	return r
}

func healthz(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func writeJSON(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(body); err != nil {
		log.Printf("writeJSON encode error: %v", err)
	}
}

func writeError(w http.ResponseWriter, status int, msg string) {
	writeJSON(w, status, map[string]string{"error": msg})
}
