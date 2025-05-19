-- dashboards.sql - Definición de áreas, KPIs y configuraciones visuales

CREATE TABLE IF NOT EXISTS dashboard_areas (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dashboard_kpis (
    id SERIAL PRIMARY KEY,
    area_id INTEGER REFERENCES dashboard_areas(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    value_type VARCHAR(20) DEFAULT 'number',
    query TEXT NOT NULL,
    position INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);

