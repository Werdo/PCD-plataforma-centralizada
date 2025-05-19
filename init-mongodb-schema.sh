#!/bin/bash

# Script: init-mongodb-schema.sh
# Aplica un esquema inicial sobre la base de datos MongoDB usando kubectl y mongosh

set -e

NAMESPACE="central-platform"
MONGO_POD=$(kubectl get pod -n "$NAMESPACE" -l app=mongodb -o jsonpath="{.items[0].metadata.name}")

if [ -z "$MONGO_POD" ]; then
  echo "❌ No se encontró el pod de MongoDB en el namespace $NAMESPACE"
  exit 1
fi

echo "📥 Ejecutando comandos iniciales sobre MongoDB..."
kubectl exec -n "$NAMESPACE" "$MONGO_POD" -- mongosh <<EOF
use centraldb

db.createCollection("config")
db.createCollection("user_logs")
db.config.createIndex({ key: 1 }, { unique: true })
db.user_logs.createIndex({ user_id: 1, timestamp: -1 })

EOF

echo "✅ Esquema inicial de MongoDB aplicado correctamente."

