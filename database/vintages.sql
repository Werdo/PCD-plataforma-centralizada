-- vintages.sql - Añadas registradas

CREATE TABLE IF NOT EXISTS vintages (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
