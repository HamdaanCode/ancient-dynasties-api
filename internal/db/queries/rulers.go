package queries

import (
	"context"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

// RulerFilter narrows a ListRulers call. Nil fields mean no filter.
type RulerFilter struct {
	CivilizationSlug *string
	DynastySlug      *string
}

const rulerColumns = `
r.id, r.slug, r.name, r.name_native, r.reign_start, r.reign_end, r.is_approximate,
r.predecessor_id, r.successor_id, r.father_id, r.mother_id, r.description,
d.slug, d.name,
c.slug, c.name
`

// ListRulers returns all rulers, optionally filtered by civilization or dynasty slug.
// Results are ordered chronologically by reign_start.
func (q *Queries) ListRulers(ctx context.Context, filter RulerFilter) ([]models.Ruler, error) {
	sql := `
		SELECT ` + rulerColumns + `
		FROM rulers r
		JOIN dynasties d ON d.id = r.dynasty_id
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE ($1::text IS NULL OR c.slug = $1)
		  AND ($2::text IS NULL OR d.slug = $2)
		ORDER BY r.reign_start NULLS LAST, r.name
	`
	rows, err := q.pool.Query(ctx, sql, filter.CivilizationSlug, filter.DynastySlug)
	if err != nil {
		return nil, fmt.Errorf("query rulers: %w", err)
	}
	defer rows.Close()

	out := []models.Ruler{}
	for rows.Next() {
		r, err := scanRuler(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate ruler rows: %w", err)
	}
	return out, nil
}

// GetRulerBySlug returns a single ruler by slug. ErrNotFound on miss.
func (q *Queries) GetRulerBySlug(ctx context.Context, slug string) (models.Ruler, error) {
	sql := `
		SELECT ` + rulerColumns + `
		FROM rulers r
		JOIN dynasties d ON d.id = r.dynasty_id
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE r.slug = $1
	`
	row := q.pool.QueryRow(ctx, sql, slug)
	r, err := scanRuler(row)
	if errors.Is(err, pgx.ErrNoRows) {
		return models.Ruler{}, ErrNotFound
	}
	return r, err
}

func scanRuler(s scanner) (models.Ruler, error) {
	var r models.Ruler
	err := s.Scan(
		&r.ID,
		&r.Slug,
		&r.Name,
		&r.NameNative,
		&r.ReignStart,
		&r.ReignEnd,
		&r.IsApproximate,
		&r.PredecessorID,
		&r.SuccessorID,
		&r.FatherID,
		&r.MotherID,
		&r.Description,
		&r.Dynasty.Slug,
		&r.Dynasty.Name,
		&r.Dynasty.Civilization.Slug,
		&r.Dynasty.Civilization.Name,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return models.Ruler{}, err
		}
		return models.Ruler{}, fmt.Errorf("scan ruler row: %w", err)
	}
	return r, nil
}
