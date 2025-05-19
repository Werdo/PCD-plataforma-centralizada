-- t301_events.sql - Eventos del gateway T301

CREATE TABLE IF NOT EXISTS t301_events (
    id SERIAL PRIMARY KEY,
    type VARCHAR(20) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    imei VARCHAR(32),
    alarm_code VARCHAR(8),
    raw TEXT NOT NULL,
    received_at TIMESTAMP DEFAULT NOW()
);

