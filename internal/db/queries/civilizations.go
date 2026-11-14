package queries

import (
	"context"
	"fmt"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

const listCivilizationsSQL = `
SELECT id, slug, name, region, era_start_year, era_end_year, description
FROM civilizations
ORDER BY era_start_year NULLS LAST, name
`

// ListCivilizations returns every civilization in the DB.
func (q *Queries) ListCivilizations(ctx context.Context) ([]models.Civilization, error) {
	rows, err := q.pool.Query(ctx, listCivilizationsSQL)
	if err != nil {
		return nil, fmt.Errorf("query civilizations: %w", err)
	}
	defer rows.Close()

	var out []models.Civilization
	for rows.Next() {
		var c models.Civilization
		if err := rows.Scan(
			&c.ID,
			&c.Slug,
			&c.Name,
			&c.Region,
			&c.EraStartYear,
			&c.EraEndYear,
			&c.Description,
		); err != nil {
			return nil, fmt.Errorf("scan civilization row: %w", err)
		}
		out = append(out, c)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate civilization rows: %w", err)
	}
	return out, nil
}
