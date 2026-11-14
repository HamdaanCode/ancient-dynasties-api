package queries

import (
	"context"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

// DynastyFilter narrows a ListDynasties call. Nil fields mean no filter.
type DynastyFilter struct {
	CivilizationSlug *string
}

const dynastyColumns = `
d.id, d.slug, d.name, d.founder_name, d.start_year, d.end_year, d.description,
c.slug, c.name
`

// ListDynasties returns all dynasties, optionally filtered by civilization slug.
// Results are ordered chronologically by start_year then alphabetically.
func (q *Queries) ListDynasties(ctx context.Context, filter DynastyFilter) ([]models.Dynasty, error) {
	sql := `
		SELECT ` + dynastyColumns + `
		FROM dynasties d
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE ($1::text IS NULL OR c.slug = $1)
		ORDER BY d.start_year NULLS LAST, d.name
	`
	rows, err := q.pool.Query(ctx, sql, filter.CivilizationSlug)
	if err != nil {
		return nil, fmt.Errorf("query dynasties: %w", err)
	}
	defer rows.Close()

	out := []models.Dynasty{}
	for rows.Next() {
		d, err := scanDynasty(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, d)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate dynasty rows: %w", err)
	}
	return out, nil
}

// GetDynastyBySlug returns a single dynasty by its slug. ErrNotFound on miss.
func (q *Queries) GetDynastyBySlug(ctx context.Context, slug string) (models.Dynasty, error) {
	sql := `
		SELECT ` + dynastyColumns + `
		FROM dynasties d
		JOIN civilizations c ON c.id = d.civilization_id
		WHERE d.slug = $1
	`
	row := q.pool.QueryRow(ctx, sql, slug)
	d, err := scanDynasty(row)
	if errors.Is(err, pgx.ErrNoRows) {
		return models.Dynasty{}, ErrNotFound
	}
	return d, err
}

// scanDynasty accepts anything with a Scan method (Row or Rows) so we can share
// the same scanning logic between list and detail queries.
type scanner interface {
	Scan(dest ...any) error
}

func scanDynasty(s scanner) (models.Dynasty, error) {
	var d models.Dynasty
	err := s.Scan(
		&d.ID,
		&d.Slug,
		&d.Name,
		&d.FounderName,
		&d.StartYear,
		&d.EndYear,
		&d.Description,
		&d.Civilization.Slug,
		&d.Civilization.Name,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return models.Dynasty{}, err
		}
		return models.Dynasty{}, fmt.Errorf("scan dynasty row: %w", err)
	}
	return d, nil
}
