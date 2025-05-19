-- locations.sql - Tabla de ubicaciones físicas dentro de la bodega

CREATE TABLE IF NOT EXISTS locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- rooms.sql - Salas específicas dentro de una ubicación

CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    temperature_control BOOLEAN DEFAULT FALSE,
    humidity_control BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

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

-- devices.sql - Dispositivos instalados en ubicaciones o elementos físicos

CREATE TABLE IF NOT EXISTS devices (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'active',
    location_id INTEGER REFERENCES locations(id),
    room_id INTEGER REFERENCES rooms(id),
    barrel_id INTEGER REFERENCES barrels(id),
    created_at TIMESTAMP DEFAULT NOW()
);

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

-- plots.sql - Parcelas de terreno controladas

CREATE TABLE IF NOT EXISTS plots (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    area_hectares DECIMAL(6,2),
    owner VARCHAR(100),
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- grids.sql - Cuadrículas dentro de una parcela

CREATE TABLE IF NOT EXISTS grids (
    id SERIAL PRIMARY KEY,
    plot_id INTEGER NOT NULL REFERENCES plots(id) ON DELETE CASCADE,
    name VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- field_sensors.sql - Sensores de campo instalados en cuadrículas

CREATE TABLE IF NOT EXISTS field_sensors (
    id SERIAL PRIMARY KEY,
    grid_id INTEGER NOT NULL REFERENCES grids(id) ON DELETE CASCADE,
    type VARCHAR(50),
    model VARCHAR(100),
    location_description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

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

-- traceability.sql - Seguimiento de procesos entre elementos físicos

CREATE TABLE IF NOT EXISTS traceability (
    id SERIAL PRIMARY KEY,
    source_barrel_id INTEGER REFERENCES barrels(id),
    target_barrel_id INTEGER REFERENCES barrels(id),
    action VARCHAR(100),
    actor VARCHAR(100),
    timestamp TIMESTAMP DEFAULT NOW()
);

-- barrel_locations.sql - Historico de ubicación de cada barrica

CREATE TABLE IF NOT EXISTS barrel_locations (
    id SERIAL PRIMARY KEY,
    barrel_id INTEGER NOT NULL REFERENCES barrels(id),
    room_id INTEGER REFERENCES rooms(id),
    moved_at TIMESTAMP DEFAULT NOW()
);

-- states.sql - Estados generales de la plataforma

CREATE TABLE IF NOT EXISTS states (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    type VARCHAR(50),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- type_catalog.sql - Catálogos para clasificación y tipos

CREATE TABLE IF NOT EXISTS type_catalog (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    group_name VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- wine_types.sql - Tipos de vino registrados

CREATE TABLE IF NOT EXISTS wine_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- vintages.sql - Añadas registradas

CREATE TABLE IF NOT EXISTS vintages (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- grape_types.sql - Variedades de uva

CREATE TABLE IF NOT EXISTS grape_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- grape_organoleptic.sql - Valores organolépticos de las uvas

CREATE TABLE IF NOT EXISTS grape_organoleptic (
    id SERIAL PRIMARY KEY,
    grape_type_id INTEGER REFERENCES grape_types(id) ON DELETE CASCADE,
    flavor_notes TEXT,
    aroma_profile TEXT,
    acidity_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- wine_organoleptic.sql - Valores organolépticos del vino

CREATE TABLE IF NOT EXISTS wine_organoleptic (
    id SERIAL PRIMARY KEY,
    wine_type_id INTEGER REFERENCES wine_types(id) ON DELETE CASCADE,
    tasting_notes TEXT,
    body VARCHAR(50),
    tannins_level VARCHAR(50),
    aging_potential VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- configurations.sql - Configuración global de sistema y parámetros

CREATE TABLE IF NOT EXISTS configurations (
    id SERIAL PRIMARY KEY,
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    description TEXT,
    updated_at TIMESTAMP DEFAULT NOW()
);

-- roles.sql - Roles del sistema

CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- groups.sql - Grupos de trabajo o permisos

CREATE TABLE IF NOT EXISTS groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- users.sql - Usuarios registrados en el sistema

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    role_id INTEGER REFERENCES roles(id),
    group_id INTEGER REFERENCES groups(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW()
);

-- user_role_group.sql - Asociación avanzada entre usuarios, roles y grupos

CREATE TABLE IF NOT EXISTS user_role_group (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    group_id INTEGER REFERENCES groups(id),
    assigned_at TIMESTAMP DEFAULT NOW()
);

-- areas.sql - Áreas funcionales para vistas o dashboards

CREATE TABLE IF NOT EXISTS areas (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- system_views.sql - Vistas del sistema accesibles desde el panel

CREATE TABLE IF NOT EXISTS system_views (
    id SERIAL PRIMARY KEY,
    area_id INTEGER REFERENCES areas(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    path VARCHAR(200) NOT NULL,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

