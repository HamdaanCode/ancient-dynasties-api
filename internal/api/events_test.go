package api

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

func TestListEvents(t *testing.T) {
	var events []models.Event
	resp := getJSON(t, "/v1/events", &events)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.GreaterOrEqual(t, len(events), 9, "4 Mesopotamian + 5 Egyptian events")

	// Chronological ordering: Victory stele ~2250 BCE should come first.
	require.NotNil(t, events[0].Year)
	assert.Equal(t, int32(-2250), *events[0].Year)
}

func TestListEventsDateRange(t *testing.T) {
	var events []models.Event

	// Neo-Babylonian window: three events between 700 and 500 BCE.
	getJSON(t, "/v1/events?from_year=-700&to_year=-500", &events)
	assert.Len(t, events, 3)

	// 3rd-millennium window: only the Naram-Sin victory.
	getJSON(t, "/v1/events?from_year=-2500&to_year=-2000", &events)
	assert.Len(t, events, 1)
	assert.Equal(t, "Victory over the Lullubi (Victory Stele of Naram-Sin)", events[0].Name)

	// Window with no events (post-Roman annexation onwards).
	getJSON(t, "/v1/events?from_year=100&to_year=500", &events)
	assert.Empty(t, events)
}

func TestListEventsHalfOpenBounds(t *testing.T) {
	var events []models.Event
	getJSON(t, "/v1/events?from_year=-700", &events)
	assert.Len(t, events, 6, "3 Mesopotamian + 3 Ptolemaic-era events after 700 BCE")

	getJSON(t, "/v1/events?to_year=-2000", &events)
	assert.Len(t, events, 1, "only the Victory Stele of Naram-Sin predates 2000 BCE")
}
