package queries

import (
	"context"
	"fmt"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

// Search runs a case-insensitive substring match against ruler names and
// dynasty names (plus their descriptions), returning the hits grouped by type.
//
// We use ILIKE here for simplicity and because the dataset is tiny. For a
// much larger corpus we would switch to Postgres full-text search via the
// gin tsvector index already created on rulers.name during Phase 1.
func (q *Queries) Search(ctx context.Context, term string) (models.SearchResult, error) {
	result := models.SearchResult{
		Query:     term,
		Rulers:    []models.Ruler{},
		Dynasties: []models.Dynasty{},
	}

	rulerSQL := `
		SELECT ` + rulerColumns + `
		FROM rulers r
		JOIN dynasties d ON d.id = r.dynasty_id
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE r.name ILIKE '%' || $1 || '%'
		   OR COALESCE(r.description, '') ILIKE '%' || $1 || '%'
		ORDER BY r.reign_start NULLS LAST, r.name
	`
	rulerRows, err := q.pool.Query(ctx, rulerSQL, term)
	if err != nil {
		return result, fmt.Errorf("query rulers: %w", err)
	}
	defer rulerRows.Close()
	for rulerRows.Next() {
		r, err := scanRuler(rulerRows)
		if err != nil {
			return result, err
		}
		result.Rulers = append(result.Rulers, r)
	}
	if err := rulerRows.Err(); err != nil {
		return result, fmt.Errorf("iterate ruler rows: %w", err)
	}

	dynastySQL := `
		SELECT ` + dynastyColumns + `
		FROM dynasties d
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE d.name ILIKE '%' || $1 || '%'
		   OR COALESCE(d.description, '') ILIKE '%' || $1 || '%'
		ORDER BY d.start_year NULLS LAST, d.name
	`
	dynastyRows, err := q.pool.Query(ctx, dynastySQL, term)
	if err != nil {
		return result, fmt.Errorf("query dynasties: %w", err)
	}
	defer dynastyRows.Close()
	for dynastyRows.Next() {
		d, err := scanDynasty(dynastyRows)
		if err != nil {
			return result, err
		}
		result.Dynasties = append(result.Dynasties, d)
	}
	if err := dynastyRows.Err(); err != nil {
		return result, fmt.Errorf("iterate dynasty rows: %w", err)
	}

	return result, nil
}
