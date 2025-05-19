-- system_views.sql - Vistas del sistema accesibles desde el panel

CREATE TABLE IF NOT EXISTS system_views (
    id SERIAL PRIMARY KEY,
    area_id INTEGER REFERENCES areas(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    path VARCHAR(200) NOT NULL,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

