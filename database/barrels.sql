-- barrels.sql - Barricas almacenadas en una sala específica

CREATE TABLE IF NOT EXISTS barrels (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    code VARCHAR(100) UNIQUE NOT NULL,
    capacity_liters INTEGER,
    wood_type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW()
);
