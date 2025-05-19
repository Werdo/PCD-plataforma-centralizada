-- grape_organoleptic.sql - Valores organolépticos de las uvas

CREATE TABLE IF NOT EXISTS grape_organoleptic (
    id SERIAL PRIMARY KEY,
    grape_type_id INTEGER REFERENCES grape_types(id) ON DELETE CASCADE,
    flavor_notes TEXT,
    aroma_profile TEXT,
    acidity_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);
