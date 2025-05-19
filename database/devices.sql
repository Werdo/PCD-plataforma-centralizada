-- devices.sql - Dispositivos instalados en ubicaciones o elementos físicos

CREATE TABLE IF NOT EXISTS devices (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'active',
    location_id INTEGER REFERENCES locations(id),
    room_id INTEGER REFERENCES rooms(id),
    barrel_id INTEGER REFERENCES barrels(id),
    created_at TIMESTAMP DEFAULT NOW()
);
