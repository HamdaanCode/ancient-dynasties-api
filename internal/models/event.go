package models

// Event is a historical event (battle, treaty, accession, death, etc.).
// Year uses integer with BCE as negative.
type Event struct {
	ID          int32   `json:"id"`
	Slug        string  `json:"slug"`
	Name        string  `json:"name"`
	EventType   string  `json:"event_type"`
	Year        *int32  `json:"year,omitempty"`
	Description *string `json:"description,omitempty"`
}
