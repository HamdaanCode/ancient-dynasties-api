package api

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

func TestListRulers(t *testing.T) {
	var rulers []models.Ruler
	resp := getJSON(t, "/v1/rulers", &rulers)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	assert.Len(t, rulers, 16, "16 Mesopotamian rulers in the seed")
}

func TestListRulersFilteredByDynasty(t *testing.T) {
	var rulers []models.Ruler
	getJSON(t, "/v1/rulers?dynasty=akkadian", &rulers)
	assert.Len(t, rulers, 5)

	getJSON(t, "/v1/rulers?dynasty=ur-iii", &rulers)
	assert.Len(t, rulers, 5)

	getJSON(t, "/v1/rulers?dynasty=neo-babylonian", &rulers)
	assert.Len(t, rulers, 3)
}

func TestListRulersFilteredByCivilization(t *testing.T) {
	var rulers []models.Ruler
	getJSON(t, "/v1/rulers?civilization=mesopotamia", &rulers)
	assert.Len(t, rulers, 16)
}

func TestGetRuler(t *testing.T) {
	var r models.Ruler
	resp := getJSON(t, "/v1/rulers/sargon-of-akkad", &r)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	assert.Equal(t, "Sargon of Akkad", r.Name)
	require.NotNil(t, r.ReignStart)
	assert.Equal(t, int32(-2334), *r.ReignStart)
	assert.Equal(t, "akkadian", r.Dynasty.Slug)
	assert.Equal(t, "mesopotamia", r.Dynasty.Civilization.Slug)
}

func TestGetRulerNotFound(t *testing.T) {
	resp := getJSON(t, "/v1/rulers/nonexistent", nil)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

// The recursive CTE tests. These are the SQL feature we want working in CI.

func TestAncestorsOfNaramSin(t *testing.T) {
	var lineage []models.RulerLineage
	resp := getJSON(t, "/v1/rulers/naram-sin/ancestors", &lineage)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.Len(t, lineage, 3, "Naram-Sin -> Manishtushu -> Sargon")

	assert.Equal(t, int32(0), lineage[0].Depth)
	assert.Equal(t, "naram-sin", lineage[0].Slug)

	assert.Equal(t, int32(1), lineage[1].Depth)
	assert.Equal(t, "manishtushu", lineage[1].Slug)

	assert.Equal(t, int32(2), lineage[2].Depth)
	assert.Equal(t, "sargon-of-akkad", lineage[2].Slug)
}

func TestSuccessorsOfSargon(t *testing.T) {
	var lineage []models.RulerLineage
	resp := getJSON(t, "/v1/rulers/sargon-of-akkad/successors", &lineage)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.Len(t, lineage, 5, "Sargon through Shar-kali-sharri")

	expected := []string{
		"sargon-of-akkad",
		"rimush",
		"manishtushu",
		"naram-sin",
		"shar-kali-sharri",
	}
	for i, want := range expected {
		assert.Equal(t, int32(i), lineage[i].Depth)
		assert.Equal(t, want, lineage[i].Slug)
	}
}

func TestLineageNotFound(t *testing.T) {
	resp := getJSON(t, "/v1/rulers/nonexistent/ancestors", nil)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)

	resp = getJSON(t, "/v1/rulers/nonexistent/successors", nil)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}
