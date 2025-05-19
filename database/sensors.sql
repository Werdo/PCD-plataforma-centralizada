-- sensors.sql - Sensores físicos conectados a dispositivos

CREATE TABLE IF NOT EXISTS sensors (
    id SERIAL PRIMARY KEY,
    device_id INTEGER NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    type VARCHAR(50),
    model VARCHAR(100),
    unit VARCHAR(20),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
