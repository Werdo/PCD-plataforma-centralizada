-- barrel_locations.sql - Historico de ubicación de cada barrica

CREATE TABLE IF NOT EXISTS barrel_locations (
    id SERIAL PRIMARY KEY,
    barrel_id INTEGER NOT NULL REFERENCES barrels(id),
    room_id INTEGER REFERENCES rooms(id),
    moved_at TIMESTAMP DEFAULT NOW()
);
