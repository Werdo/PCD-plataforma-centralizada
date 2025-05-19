#!/bin/bash

# Script: init-create-postgres-db.sh
# Crea la base de datos 'centraldb' dentro del pod PostgreSQL si no existe

set -e

NAMESPACE="central-platform"
DB_NAME="centraldb"
POD=$(kubectl get pod -n $NAMESPACE -l app=postgresql -o jsonpath="{.items[0].metadata.name}")

if [ -z "$POD" ]; then
  echo "❌ No se encontró el pod de PostgreSQL."
  exit 1
fi

echo "🔍 Verificando existencia de la base de datos '$DB_NAME'..."
DB_EXISTS=$(kubectl exec -n $NAMESPACE "$POD" -- bash -c "psql -U \"$POSTGRES_USER\" -tAc \"SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';\"")

if [ "$DB_EXISTS" = "1" ]; then
  echo "✅ La base de datos '$DB_NAME' ya existe."
else
  echo "🆕 Creando base de datos '$DB_NAME'..."
  kubectl exec -n $NAMESPACE "$POD" -- bash -c "psql -U \"$POSTGRES_USER\" -c \"CREATE DATABASE $DB_NAME;\""
  echo "✅ Base de datos '$DB_NAME' creada."
fi

