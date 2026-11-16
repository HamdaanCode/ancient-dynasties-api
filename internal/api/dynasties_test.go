package api

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

func TestListDynasties(t *testing.T) {
	var dynasties []models.Dynasty
	resp := getJSON(t, "/v1/dynasties", &dynasties)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.GreaterOrEqual(t, len(dynasties), 8, "4 Mesopotamian + 4 Egyptian")

	// Chronological ordering: oldest dynasty seeded is Egypt 4th Dynasty (~ -2613).
	assert.Equal(t, "egypt-4th-dynasty", dynasties[0].Slug)

	// Both civilizations represented.
	civSlugs := make(map[string]bool)
	for _, d := range dynasties {
		civSlugs[d.Civilization.Slug] = true
	}
	assert.True(t, civSlugs["mesopotamia"])
	assert.True(t, civSlugs["egypt"])
}

func TestListDynastiesFilteredByCivilization(t *testing.T) {
	var dynasties []models.Dynasty

	getJSON(t, "/v1/dynasties?civilization=mesopotamia", &dynasties)
	assert.Len(t, dynasties, 4)

	getJSON(t, "/v1/dynasties?civilization=egypt", &dynasties)
	assert.Len(t, dynasties, 4)

	getJSON(t, "/v1/dynasties?civilization=nonexistent", &dynasties)
	assert.Empty(t, dynasties)
}

func TestGetDynasty(t *testing.T) {
	var d models.Dynasty
	resp := getJSON(t, "/v1/dynasties/akkadian", &d)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	assert.Equal(t, "Akkadian Empire", d.Name)
	assert.Equal(t, "mesopotamia", d.Civilization.Slug)
	require.NotNil(t, d.StartYear)
	assert.Equal(t, int32(-2334), *d.StartYear)
}

func TestGetDynastyNotFound(t *testing.T) {
	resp := getJSON(t, "/v1/dynasties/nonexistent", nil)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestListDynastyRulers(t *testing.T) {
	var rulers []models.Ruler
	resp := getJSON(t, "/v1/dynasties/akkadian/rulers", &rulers)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.Len(t, rulers, 5, "the 5 Akkadian kings")
	assert.Equal(t, "sargon-of-akkad", rulers[0].Slug)
	assert.Equal(t, "shar-kali-sharri", rulers[4].Slug)
}

func TestListDynastyRulersNotFound(t *testing.T) {
	resp := getJSON(t, "/v1/dynasties/nonexistent/rulers", nil)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}
