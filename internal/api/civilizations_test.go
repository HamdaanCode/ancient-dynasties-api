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
	require.Len(t, civs, 1)
	assert.Equal(t, "mesopotamia", civs[0].Slug)
	assert.Equal(t, "Mesopotamia", civs[0].Name)
	require.NotNil(t, civs[0].EraStartYear)
	assert.Equal(t, int32(-3500), *civs[0].EraStartYear)
}
