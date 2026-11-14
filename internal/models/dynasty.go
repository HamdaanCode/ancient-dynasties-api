package models

// CivilizationRef is the slim form of Civilization that gets embedded inside
// Dynasty and Ruler responses so a client never needs a second request just
// to find out which civilization an entity belongs to.
type CivilizationRef struct {
	Slug string `json:"slug"`
	Name string `json:"name"`
}

// Dynasty represents one ruling house inside a civilization.
type Dynasty struct {
	ID           int32           `json:"id"`
	Slug         string          `json:"slug"`
	Name         string          `json:"name"`
	FounderName  *string         `json:"founder_name,omitempty"`
	StartYear    *int32          `json:"start_year,omitempty"`
	EndYear      *int32          `json:"end_year,omitempty"`
	Description  *string         `json:"description,omitempty"`
	Civilization CivilizationRef `json:"civilization"`
}
