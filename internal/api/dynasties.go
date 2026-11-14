package api

import (
	"errors"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

// listDynasties is GET /v1/dynasties?civilization=slug
func (a *API) listDynasties(w http.ResponseWriter, r *http.Request) {
	filter := queries.DynastyFilter{
		CivilizationSlug: optionalQuery(r, "civilization"),
	}
	dynasties, err := a.Q.ListDynasties(r.Context(), filter)
	if err != nil {
		log.Printf("list dynasties: %v", err)
		writeError(w, http.StatusInternalServerError, "failed to list dynasties")
		return
	}
	writeJSON(w, http.StatusOK, dynasties)
}

// getDynasty is GET /v1/dynasties/{slug}
func (a *API) getDynasty(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")
	d, err := a.Q.GetDynastyBySlug(r.Context(), slug)
	if errors.Is(err, queries.ErrNotFound) {
		writeError(w, http.StatusNotFound, "dynasty not found")
		return
	}
	if err != nil {
		log.Printf("get dynasty %q: %v", slug, err)
		writeError(w, http.StatusInternalServerError, "failed to load dynasty")
		return
	}
	writeJSON(w, http.StatusOK, d)
}

// listDynastyRulers is GET /v1/dynasties/{slug}/rulers
func (a *API) listDynastyRulers(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")

	// Confirm the dynasty exists so we can return 404 rather than an empty list
	// when the client requests a slug that does not match.
	if _, err := a.Q.GetDynastyBySlug(r.Context(), slug); err != nil {
		if errors.Is(err, queries.ErrNotFound) {
			writeError(w, http.StatusNotFound, "dynasty not found")
			return
		}
		log.Printf("check dynasty %q: %v", slug, err)
		writeError(w, http.StatusInternalServerError, "failed to load dynasty")
		return
	}

	rulers, err := a.Q.ListRulers(r.Context(), queries.RulerFilter{DynastySlug: &slug})
	if err != nil {
		log.Printf("list rulers for %q: %v", slug, err)
		writeError(w, http.StatusInternalServerError, "failed to list rulers")
		return
	}
	writeJSON(w, http.StatusOK, rulers)
}

// optionalQuery returns a pointer to the query value, or nil when absent or empty.
// Lets us pass clean NULLs to Postgres for the `WHERE ($1 IS NULL OR col = $1)` pattern.
func optionalQuery(r *http.Request, key string) *string {
	v := r.URL.Query().Get(key)
	if v == "" {
		return nil
	}
	return &v
}
