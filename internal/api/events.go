package api

import (
	"log"
	"net/http"
	"strconv"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/db/queries"
)

// listEvents is GET /v1/events?from_year=&to_year=
// Years are integers with BCE as negative (so from=-2500&to=-2000 gives 3rd millennium BCE events).
func (a *API) listEvents(w http.ResponseWriter, r *http.Request) {
	filter := queries.EventFilter{
		FromYear: optionalInt(r, "from_year"),
		ToYear:   optionalInt(r, "to_year"),
	}
	events, err := a.Q.ListEvents(r.Context(), filter)
	if err != nil {
		log.Printf("list events: %v", err)
		writeError(w, http.StatusInternalServerError, "failed to list events")
		return
	}
	writeJSON(w, http.StatusOK, events)
}

// optionalInt reads a query parameter and returns it as *int32.
// Returns nil if the parameter is absent or empty. Returns nil with no error
// on a malformed value so garbage input quietly degrades to "no filter".
func optionalInt(r *http.Request, key string) *int32 {
	raw := r.URL.Query().Get(key)
	if raw == "" {
		return nil
	}
	n, err := strconv.ParseInt(raw, 10, 32)
	if err != nil {
		return nil
	}
	v := int32(n)
	return &v
}
