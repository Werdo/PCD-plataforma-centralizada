-- production_processes.sql - Procesos productivos identificables

CREATE TABLE IF NOT EXISTS production_processes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

