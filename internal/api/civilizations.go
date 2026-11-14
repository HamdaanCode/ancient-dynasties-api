package api

import (
	"log"
	"net/http"
)

// listCivilizations is GET /v1/civilizations.
func (a *API) listCivilizations(w http.ResponseWriter, r *http.Request) {
	civs, err := a.Q.ListCivilizations(r.Context())
	if err != nil {
		log.Printf("list civilizations: %v", err)
		writeError(w, http.StatusInternalServerError, "failed to list civilizations")
		return
	}
	writeJSON(w, http.StatusOK, civs)
}
