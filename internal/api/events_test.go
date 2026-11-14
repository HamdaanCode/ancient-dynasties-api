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
	require.Len(t, events, 4, "the 4 Mesopotamian seed events")

	// Chronological ordering: Victory stele ~2250 BCE first.
	require.NotNil(t, events[0].Year)
	assert.Equal(t, int32(-2250), *events[0].Year)
	assert.Equal(t, "Victory over the Lullubi (Victory Stele of Naram-Sin)", events[0].Name)
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

	// Window with no events.
	getJSON(t, "/v1/events?from_year=-100&to_year=100", &events)
	assert.Empty(t, events)
}

func TestListEventsHalfOpenBounds(t *testing.T) {
	var events []models.Event
	getJSON(t, "/v1/events?from_year=-700", &events)
	assert.Len(t, events, 3, "every event after 700 BCE")

	getJSON(t, "/v1/events?to_year=-2000", &events)
	assert.Len(t, events, 1, "every event up to 2000 BCE")
}
