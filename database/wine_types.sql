-- wine_types.sql - Tipos de vino registrados

CREATE TABLE IF NOT EXISTS wine_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
