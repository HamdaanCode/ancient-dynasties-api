package api

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

func TestSearchRequiresQ(t *testing.T) {
	resp := getJSON(t, "/v1/search", nil)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)

	resp = getJSON(t, "/v1/search?q=", nil)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}

func TestSearchAkkad(t *testing.T) {
	var result models.SearchResult
	resp := getJSON(t, "/v1/search?q=akkad", &result)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	assert.Equal(t, "akkad", result.Query)

	// At minimum: 5 Akkadian rulers + Akkadian Empire dynasty.
	assert.GreaterOrEqual(t, len(result.Rulers), 5)
	assert.GreaterOrEqual(t, len(result.Dynasties), 1)

	rulerSlugs := make(map[string]bool)
	for _, r := range result.Rulers {
		rulerSlugs[r.Slug] = true
	}
	assert.True(t, rulerSlugs["sargon-of-akkad"], "sargon should match 'akkad'")
	assert.True(t, rulerSlugs["naram-sin"], "naram-sin should match 'akkad' via description")

	dynastyNames := make(map[string]bool)
	for _, d := range result.Dynasties {
		dynastyNames[d.Name] = true
	}
	assert.True(t, dynastyNames["Akkadian Empire"], "Akkadian Empire should match by name")
}

func TestSearchSargon(t *testing.T) {
	var result models.SearchResult
	getJSON(t, "/v1/search?q=sargon", &result)
	assert.GreaterOrEqual(t, len(result.Rulers), 1, "Sargon himself should match")

	found := false
	for _, r := range result.Rulers {
		if r.Slug == "sargon-of-akkad" {
			found = true
		}
	}
	assert.True(t, found)
}

func TestSearchNoMatch(t *testing.T) {
	var result models.SearchResult
	getJSON(t, "/v1/search?q=xyzzy", &result)
	assert.Empty(t, result.Rulers)
	assert.Empty(t, result.Dynasties)
}
