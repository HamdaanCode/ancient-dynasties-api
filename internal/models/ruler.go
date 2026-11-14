package models

// DynastyRef is the slim form of Dynasty embedded inside Ruler responses,
// plus the civilization that owns the dynasty.
type DynastyRef struct {
	Slug         string          `json:"slug"`
	Name         string          `json:"name"`
	Civilization CivilizationRef `json:"civilization"`
}

// Ruler represents one monarch inside a dynasty.
// Year fields use integers with BCE as negative.
type Ruler struct {
	ID            int32      `json:"id"`
	Slug          string     `json:"slug"`
	Name          string     `json:"name"`
	NameNative    *string    `json:"name_native,omitempty"`
	ReignStart    *int32     `json:"reign_start,omitempty"`
	ReignEnd      *int32     `json:"reign_end,omitempty"`
	IsApproximate bool       `json:"is_approximate"`
	PredecessorID *int32     `json:"predecessor_id,omitempty"`
	SuccessorID   *int32     `json:"successor_id,omitempty"`
	FatherID      *int32     `json:"father_id,omitempty"`
	MotherID      *int32     `json:"mother_id,omitempty"`
	Description   *string    `json:"description,omitempty"`
	Dynasty       DynastyRef `json:"dynasty"`
}
