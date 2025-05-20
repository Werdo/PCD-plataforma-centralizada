#!/bin/bash

# Script: init-postgres-schema.sh
# Carga el esquema completo de PostgreSQL desde los SQL de /home/ppelaez/scripts/database

set -e

NAMESPACE="central-platform"
DB_NAME="centraldb"
SCHEMA_FILE="/home/ppelaez/scripts/database/base-schema.sql"

POD=$(kubectl get pod -n "$NAMESPACE" -l app=postgresql -o jsonpath="{.items[0].metadata.name}")

if [ -z "$POD" ]; then
  echo "❌ No se encontró el pod de PostgreSQL."
  exit 1
fi

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "❌ No se encontró $SCHEMA_FILE"
  exit 1
fi

echo "📥 Cargando esquema de PostgreSQL desde $(basename "$SCHEMA_FILE")..."
kubectl exec -i -n "$NAMESPACE" "$POD" -- psql -U "$POSTGRES_USER" -d "$DB_NAME" -f - < "$SCHEMA_FILE"

echo "✅ Esquema de PostgreSQL aplicado correctamente."
