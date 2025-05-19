-- grids.sql - Cuadrículas dentro de una parcela

CREATE TABLE IF NOT EXISTS grids (
    id SERIAL PRIMARY KEY,
    plot_id INTEGER NOT NULL REFERENCES plots(id) ON DELETE CASCADE,
    name VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
