package api

import (
	"errors"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

// listRulers is GET /v1/rulers?civilization=slug&dynasty=slug
func (a *API) listRulers(w http.ResponseWriter, r *http.Request) {
	filter := queries.RulerFilter{
		CivilizationSlug: optionalQuery(r, "civilization"),
		DynastySlug:      optionalQuery(r, "dynasty"),
	}
	rulers, err := a.Q.ListRulers(r.Context(), filter)
	if err != nil {
		log.Printf("list rulers: %v", err)
		writeError(w, http.StatusInternalServerError, "failed to list rulers")
		return
	}
	writeJSON(w, http.StatusOK, rulers)
}

// getRuler is GET /v1/rulers/{slug}
func (a *API) getRuler(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")
	ruler, err := a.Q.GetRulerBySlug(r.Context(), slug)
	if errors.Is(err, queries.ErrNotFound) {
		writeError(w, http.StatusNotFound, "ruler not found")
		return
	}
	if err != nil {
		log.Printf("get ruler %q: %v", slug, err)
		writeError(w, http.StatusInternalServerError, "failed to load ruler")
		return
	}
	writeJSON(w, http.StatusOK, ruler)
}
