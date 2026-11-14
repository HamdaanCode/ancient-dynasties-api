package models

// Civilization is the top-level grouping that contains many dynasties.
// Year fields use integers with BCE as negative (Sumer era_start ~= -3500).
type Civilization struct {
	ID            int32   `json:"id"`
	Slug          string  `json:"slug"`
	Name          string  `json:"name"`
	Region        *string `json:"region,omitempty"`
	EraStartYear  *int32  `json:"era_start_year,omitempty"`
	EraEndYear    *int32  `json:"era_end_year,omitempty"`
	Description   *string `json:"description,omitempty"`
}
