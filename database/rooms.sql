-- rooms.sql - Salas específicas dentro de una ubicación

CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    temperature_control BOOLEAN DEFAULT FALSE,
    humidity_control BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
