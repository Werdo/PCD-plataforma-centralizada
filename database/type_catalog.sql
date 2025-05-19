-- type_catalog.sql - Catálogos para clasificación y tipos

CREATE TABLE IF NOT EXISTS type_catalog (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    group_name VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
