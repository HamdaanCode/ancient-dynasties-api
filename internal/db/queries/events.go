package queries

import (
	"context"
	"fmt"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

// EventFilter narrows ListEvents by year range. Nil fields mean no bound on that side.
type EventFilter struct {
	FromYear *int32
	ToYear   *int32
}

// ListEvents returns events in the given year range, ordered chronologically.
// Both bounds are inclusive; years are stored as integers with BCE as negative.
func (q *Queries) ListEvents(ctx context.Context, filter EventFilter) ([]models.Event, error) {
	sql := `
		SELECT id, slug, name, event_type, year, description
		FROM events
		WHERE ($1::int IS NULL OR year >= $1)
		  AND ($2::int IS NULL OR year <= $2)
		ORDER BY year NULLS LAST, name
	`
	rows, err := q.pool.Query(ctx, sql, filter.FromYear, filter.ToYear)
	if err != nil {
		return nil, fmt.Errorf("query events: %w", err)
	}
	defer rows.Close()

	out := []models.Event{}
	for rows.Next() {
		var e models.Event
		if err := rows.Scan(
			&e.ID,
			&e.Slug,
			&e.Name,
			&e.EventType,
			&e.Year,
			&e.Description,
		); err != nil {
			return nil, fmt.Errorf("scan event row: %w", err)
		}
		out = append(out, e)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate event rows: %w", err)
	}
	return out, nil
}
