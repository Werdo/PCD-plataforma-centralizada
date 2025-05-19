-- grape_types.sql - Variedades de uva

CREATE TABLE IF NOT EXISTS grape_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);
