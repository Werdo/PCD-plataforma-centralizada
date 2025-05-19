-- user_role_group.sql - Asociación avanzada entre usuarios, roles y grupos

CREATE TABLE IF NOT EXISTS user_role_group (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    group_id INTEGER REFERENCES groups(id),
    assigned_at TIMESTAMP DEFAULT NOW()
);

