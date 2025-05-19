-- field_sensors.sql - Sensores de campo instalados en cuadrículas

CREATE TABLE IF NOT EXISTS field_sensors (
    id SERIAL PRIMARY KEY,
    grid_id INTEGER NOT NULL REFERENCES grids(id) ON DELETE CASCADE,
    type VARCHAR(50),
    model VARCHAR(100),
    location_description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
