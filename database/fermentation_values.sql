-- fermentation_values.sql - Valores organolépticos y de fermentación registrados

CREATE TABLE IF NOT EXISTS fermentation_values (
    id SERIAL PRIMARY KEY,
    process_id INTEGER REFERENCES production_processes(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2),
    ph DECIMAL(4,2),
    brix DECIMAL(5,2),
    density DECIMAL(6,3),
    recorded_at TIMESTAMP DEFAULT NOW()
);
