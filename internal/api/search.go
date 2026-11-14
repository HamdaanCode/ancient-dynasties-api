package api

import (
	"log"
	"net/http"
	"strings"
)

// searchHandler is GET /v1/search?q=
// Returns a grouped response with ruler and dynasty hits.
func (a *API) searchHandler(w http.ResponseWriter, r *http.Request) {
	q := strings.TrimSpace(r.URL.Query().Get("q"))
	if q == "" {
		writeError(w, http.StatusBadRequest, "missing required query parameter 'q'")
		return
	}

	result, err := a.Q.Search(r.Context(), q)
	if err != nil {
		log.Printf("search %q: %v", q, err)
		writeError(w, http.StatusInternalServerError, "search failed")
		return
	}
	writeJSON(w, http.StatusOK, result)
}
