-- plots.sql - Parcelas de terreno controladas

CREATE TABLE IF NOT EXISTS plots (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    area_hectares DECIMAL(6,2),
    owner VARCHAR(100),
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

