-- traceability.sql - Seguimiento de procesos entre elementos físicos

CREATE TABLE IF NOT EXISTS traceability (
    id SERIAL PRIMARY KEY,
    source_barrel_id INTEGER REFERENCES barrels(id),
    target_barrel_id INTEGER REFERENCES barrels(id),
    action VARCHAR(100),
    actor VARCHAR(100),
    timestamp TIMESTAMP DEFAULT NOW()
);
