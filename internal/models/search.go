package models

// SearchResult groups the search hits by entity type so the client knows
// what it got back without having to inspect each object.
type SearchResult struct {
	Query     string     `json:"query"`
	Rulers    []Ruler    `json:"rulers"`
	Dynasties []Dynasty  `json:"dynasties"`
}
