-- ancient-dynasties-api initial schema
-- Year values are stored as INTEGER with BCE as negative (e.g. Sargon of Akkad ≈ -2334).
-- All year columns allow approximation; use is_approximate flags where known.

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATIONS
-- Top-level grouping. One civilization contains many dynasties.
-- ---------------------------------------------------------------------------
CREATE TABLE civilizations (
    id              SERIAL PRIMARY KEY,
    slug            TEXT NOT NULL UNIQUE,                 -- e.g. 'mesopotamia'
    name            TEXT NOT NULL,                        -- e.g. 'Mesopotamia'
    region          TEXT,                                 -- geographic region
    era_start_year  INTEGER,                              -- earliest attested year (negative = BCE)
    era_end_year    INTEGER,                              -- end of the civilization proper
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
CREATE TABLE dynasties (
    id              SERIAL PRIMARY KEY,
    civilization_id INTEGER NOT NULL REFERENCES civilizations(id) ON DELETE CASCADE,
    slug            TEXT NOT NULL UNIQUE,                 -- e.g. 'akkadian'
    name            TEXT NOT NULL,                        -- e.g. 'Akkadian Empire'
    founder_name    TEXT,                                 -- captured as string even if ruler not yet in rulers table
    start_year      INTEGER,
    end_year        INTEGER,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dynasties_civilization_id ON dynasties(civilization_id);

-- ---------------------------------------------------------------------------
-- RULERS
-- Self-referencing columns for lineage (father/mother) and reign order (predecessor/successor)
-- support recursive-CTE queries.
-- ---------------------------------------------------------------------------
CREATE TABLE rulers (
    id              SERIAL PRIMARY KEY,
    dynasty_id      INTEGER NOT NULL REFERENCES dynasties(id) ON DELETE CASCADE,
    slug            TEXT NOT NULL UNIQUE,                 -- e.g. 'sargon-of-akkad'
    name            TEXT NOT NULL,                        -- common English name
    name_native     TEXT,                                 -- cuneiform transliteration where available
    reign_start     INTEGER,                              -- year (BCE as negative)
    reign_end       INTEGER,
    is_approximate  BOOLEAN NOT NULL DEFAULT FALSE,       -- whether reign dates are estimates
    predecessor_id  INTEGER REFERENCES rulers(id) ON DELETE SET NULL,
    successor_id    INTEGER REFERENCES rulers(id) ON DELETE SET NULL,
    father_id       INTEGER REFERENCES rulers(id) ON DELETE SET NULL,
    mother_id       INTEGER REFERENCES rulers(id) ON DELETE SET NULL,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rulers_dynasty_id ON rulers(dynasty_id);
CREATE INDEX idx_rulers_reign_start ON rulers(reign_start);
CREATE INDEX idx_rulers_father_id ON rulers(father_id);
CREATE INDEX idx_rulers_predecessor_id ON rulers(predecessor_id);

-- Full-text search index on ruler names (powers /v1/search)
CREATE INDEX idx_rulers_name_fts ON rulers USING gin(to_tsvector('simple', name));

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
CREATE TABLE events (
    id              SERIAL PRIMARY KEY,
    slug            TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,                        -- e.g. 'Fall of Nineveh'
    event_type      TEXT NOT NULL,                        -- 'battle' | 'accession' | 'death' | 'treaty' | 'founding' | ...
    year            INTEGER,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_events_year ON events(year);
CREATE INDEX idx_events_event_type ON events(event_type);

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
CREATE TABLE places (
    id              SERIAL PRIMARY KEY,
    slug            TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,                        -- ancient name, e.g. 'Ur'
    modern_name     TEXT,                                 -- modern name, e.g. 'Tell el-Muqayyar'
    latitude        NUMERIC(8, 5),
    longitude       NUMERIC(8, 5),
    era_start_year  INTEGER,
    era_end_year    INTEGER,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- JOIN TABLES
-- ---------------------------------------------------------------------------
CREATE TABLE rulers_events (
    ruler_id        INTEGER NOT NULL REFERENCES rulers(id) ON DELETE CASCADE,
    event_id        INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    role            TEXT,                                 -- e.g. 'victor', 'defeated', 'participant'
    PRIMARY KEY (ruler_id, event_id)
);

CREATE INDEX idx_rulers_events_event_id ON rulers_events(event_id);

CREATE TABLE rulers_places (
    ruler_id        INTEGER NOT NULL REFERENCES rulers(id) ON DELETE CASCADE,
    place_id        INTEGER NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    context         TEXT,                                 -- e.g. 'capital', 'birthplace', 'buried'
    PRIMARY KEY (ruler_id, place_id, context)
);

CREATE INDEX idx_rulers_places_place_id ON rulers_places(place_id);

COMMIT;
