package api

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

func TestHealthz(t *testing.T) {
	var body map[string]string
	resp := getJSON(t, "/healthz", &body)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	assert.Equal(t, "ok", body["status"])
}

func TestListCivilizations(t *testing.T) {
	var civs []models.Civilization
	resp := getJSON(t, "/v1/civilizations", &civs)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	require.GreaterOrEqual(t, len(civs), 2, "at least Mesopotamia and Egypt")

	slugs := make(map[string]bool)
	for _, c := range civs {
		slugs[c.Slug] = true
	}
	assert.True(t, slugs["mesopotamia"])
	assert.True(t, slugs["egypt"])
}
