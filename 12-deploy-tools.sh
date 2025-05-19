#!/bin/bash

# Script: 12-deploy-tools.sh
# Aplica únicamente los manifiestos de Passbolt y RustDesk en el clúster

set -e

FILE="/home/ppelaez/plataforma-centralizada/k8s/tools/passbolt-rustdesk.yaml"

echo "🚀 Aplicando servicios: Passbolt y RustDesk..."

if [ ! -f "$FILE" ]; then
  echo "❌ El archivo $FILE no existe. Asegúrate de haberlo creado."
  exit 1
fi

kubectl apply -f "$FILE"

echo "⏳ Esperando deployments..."
kubectl rollout status deployment passbolt -n central-platform --timeout=120s
kubectl rollout status deployment rustdesk-server -n central-platform --timeout=120s

echo "✅ Servicios Passbolt y RustDesk desplegados correctamente."

IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
echo ""
echo "🌐 Accesos:"
echo "🔐 http://passbolt.emiliomoro.local → Passbolt"
echo "🖥️ http://rustdesk.emiliomoro.local → RustDesk Web Interface (puerto 21118)"

