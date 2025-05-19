#!/bin/bash

# Script: 00-prepare-database.sh
# Ejecuta la preparación completa de PostgreSQL y MongoDB: creación, esquema y validación

set -e

echo "🧩 Iniciando preparación completa de base de datos..."

# Crear base de datos PostgreSQL si no existe
if [ -f "/home/ppelaez/scripts/init-create-postgres-db.sh" ]; then
  bash /home/ppelaez/scripts/init-create-postgres-db.sh
else
  echo "⚠️ init-create-postgres-db.sh no encontrado"
fi

# Cargar estructura PostgreSQL
if [ -f "/home/ppelaez/scripts/init-postgres-schema.sh" ]; then
  bash /home/ppelaez/scripts/init-postgres-schema.sh
else
  echo "⚠️ init-postgres-schema.sh no encontrado"
fi

# Preparar MongoDB (si aplica)
if [ -f "/home/ppelaez/scripts/init-mongodb-schema.sh" ]; then
  bash /home/ppelaez/scripts/init-mongodb-schema.sh
else
  echo "⚠️ init-mongodb-schema.sh no encontrado"
fi

echo "✅ Preparación de base de datos finalizada. Ya puedes continuar con el despliegue de imágenes y microservicios."

