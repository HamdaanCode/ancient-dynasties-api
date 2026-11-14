package queries

import (
	"context"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"

	"github.com/HamdaanCode/ancient-dynasties-api/internal/models"
)

// Walk shape shared by both queries. Only the SQL and the relationship
// (father vs successor) differs between ancestors and successors.
const lineageSelect = `
SELECT lin.depth,
       r.id, r.slug, r.name, r.name_native, r.reign_start, r.reign_end,
       r.is_approximate, r.predecessor_id, r.successor_id, r.father_id,
       r.mother_id, r.description,
       d.slug, d.name,
       c.slug, c.name
FROM lin
JOIN rulers r         ON r.id = lin.id
JOIN dynasties d      ON d.id = r.dynasty_id
JOIN civilizations c  ON c.id = d.civilization_id
ORDER BY lin.depth
`

// ListAncestors walks the father_id chain backwards from the given ruler.
// depth 0 is the ruler itself, depth 1 is their father, and so on.
func (q *Queries) ListAncestors(ctx context.Context, slug string) ([]models.RulerLineage, error) {
	sql := `
WITH RECURSIVE lin AS (
    SELECT id, father_id, 0 AS depth
    FROM rulers
    WHERE slug = $1
    UNION ALL
    SELECT r.id, r.father_id, l.depth + 1
    FROM rulers r
    JOIN lin l ON r.id = l.father_id
)
` + lineageSelect
	return q.scanLineage(ctx, sql, slug)
}

// ListSuccessors walks the successor_id chain forwards from the given ruler.
// depth 0 is the ruler itself, depth 1 is their immediate successor, and so on.
func (q *Queries) ListSuccessors(ctx context.Context, slug string) ([]models.RulerLineage, error) {
	sql := `
WITH RECURSIVE lin AS (
    SELECT id, successor_id, 0 AS depth
    FROM rulers
    WHERE slug = $1
    UNION ALL
    SELECT r.id, r.successor_id, l.depth + 1
    FROM rulers r
    JOIN lin l ON r.id = l.successor_id
)
` + lineageSelect
	return q.scanLineage(ctx, sql, slug)
}

func (q *Queries) scanLineage(ctx context.Context, sql, slug string) ([]models.RulerLineage, error) {
	rows, err := q.pool.Query(ctx, sql, slug)
	if err != nil {
		return nil, fmt.Errorf("query lineage: %w", err)
	}
	defer rows.Close()

	out := []models.RulerLineage{}
	for rows.Next() {
		var rl models.RulerLineage
		err := rows.Scan(
			&rl.Depth,
			&rl.Ruler.ID,
			&rl.Ruler.Slug,
			&rl.Ruler.Name,
			&rl.Ruler.NameNative,
			&rl.Ruler.ReignStart,
			&rl.Ruler.ReignEnd,
			&rl.Ruler.IsApproximate,
			&rl.Ruler.PredecessorID,
			&rl.Ruler.SuccessorID,
			&rl.Ruler.FatherID,
			&rl.Ruler.MotherID,
			&rl.Ruler.Description,
			&rl.Ruler.Dynasty.Slug,
			&rl.Ruler.Dynasty.Name,
			&rl.Ruler.Dynasty.Civilization.Slug,
			&rl.Ruler.Dynasty.Civilization.Name,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return nil, ErrNotFound
			}
			return nil, fmt.Errorf("scan lineage row: %w", err)
		}
		out = append(out, rl)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate lineage rows: %w", err)
	}
	return out, nil
}
