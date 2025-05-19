-- wine_organoleptic.sql - Valores organolépticos del vino

CREATE TABLE IF NOT EXISTS wine_organoleptic (
    id SERIAL PRIMARY KEY,
    wine_type_id INTEGER REFERENCES wine_types(id) ON DELETE CASCADE,
    tasting_notes TEXT,
    body VARCHAR(50),
    tannins_level VARCHAR(50),
    aging_potential VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);
