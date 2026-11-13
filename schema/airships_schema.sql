-- Modular SQLite schema for luftskepp / airships research
-- Designed for easy extension and later Go / other language clients

PRAGMA foreign_keys = ON;

-- ============================================================
-- Core: Airships
-- ============================================================
CREATE TABLE IF NOT EXISTS airships (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    canonical_name      TEXT NOT NULL,
    production_number   TEXT,
    manufacturer        TEXT,
    country             TEXT,
    construction_type   TEXT,
    first_flight        TEXT,
    last_flight_or_fate TEXT,
    length_m            REAL,
    diameter_m          REAL,
    volume_m3           REAL,
    gas_type            TEXT,
    useful_lift_kg      REAL,
    max_speed_kmh       REAL,
    engines_summary     TEXT,
    passengers_crew     TEXT,
    usage               TEXT,
    notes               TEXT,
    created_at          TEXT DEFAULT (datetime('now')),
    updated_at          TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_airships_canonical ON airships(canonical_name);
CREATE INDEX IF NOT EXISTS idx_airships_type ON airships(construction_type);
CREATE INDEX IF NOT EXISTS idx_airships_manufacturer ON airships(manufacturer);

-- ============================================================
-- Classification / Tags (many-to-many)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    parent_id   INTEGER REFERENCES categories(id),
    name        TEXT NOT NULL UNIQUE,
    description TEXT,
    kind        TEXT
);

CREATE TABLE IF NOT EXISTS airship_categories (
    airship_id  INTEGER NOT NULL REFERENCES airships(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (airship_id, category_id)
);

-- ============================================================
-- Terminology / Glossary (the living dictionary)
-- ============================================================
CREATE TABLE IF NOT EXISTS terms (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    canonical_term  TEXT NOT NULL,
    language        TEXT NOT NULL DEFAULT 'sv',
    category        TEXT,
    definition      TEXT,
    historical_notes TEXT,
    confidence      TEXT DEFAULT 'medium',
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_terms_canonical_lang ON terms(canonical_term, language);

CREATE TABLE IF NOT EXISTS term_variants (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    term_id     INTEGER NOT NULL REFERENCES terms(id) ON DELETE CASCADE,
    variant     TEXT NOT NULL,
    source      TEXT,
    notes       TEXT,
    UNIQUE(term_id, variant)
);

CREATE INDEX IF NOT EXISTS idx_term_variants_variant ON term_variants(variant);

CREATE TABLE IF NOT EXISTS term_relations (
    term_id         INTEGER NOT NULL REFERENCES terms(id) ON DELETE CASCADE,
    related_term_id INTEGER NOT NULL REFERENCES terms(id) ON DELETE CASCADE,
    relation_type   TEXT,
    PRIMARY KEY (term_id, related_term_id)
);

-- ============================================================
-- Sources & provenance
-- ============================================================
CREATE TABLE IF NOT EXISTS sources (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       TEXT,
    source_type TEXT,
    path_or_url TEXT,
    notes       TEXT
);

CREATE TABLE IF NOT EXISTS airship_sources (
    airship_id  INTEGER NOT NULL REFERENCES airships(id) ON DELETE CASCADE,
    source_id   INTEGER NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
    PRIMARY KEY (airship_id, source_id)
);

-- ============================================================
-- Simple view for quick searching of terms + variants
-- ============================================================
CREATE VIEW IF NOT EXISTS v_term_search AS
SELECT
    t.id            AS term_id,
    t.canonical_term,
    t.language,
    t.category,
    t.definition,
    t.historical_notes,
    t.confidence,
    v.variant,
    v.source        AS variant_source
FROM terms t
LEFT JOIN term_variants v ON v.term_id = t.id;
