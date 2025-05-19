#!/bin/bash

# Script: 99-refresh-all.sh
# Reconstruye, importa y reinicia todos los servicios de la plataforma

set -e

echo "♻️ [1/3] Ejecutando build completo..."
./scripts/16-rebuild-all.sh --keep

echo "📥 [2/3] Importando imágenes en containerd..."
./scripts/07-import-images.sh

echo "☸️ [3/3] Reiniciando deployments..."
SERVICES=(
  api-rest
  websocket
  alerts
  frontend-facit
  frontend-fyr
  gateway-t301
  gateway-goodwe
  openai-proxy
)

for SVC in "${SERVICES[@]}"; do
  echo "🔁 Reiniciando: $SVC"
  kubectl rollout restart deployment "$SVC" -n central-platform
done

echo "✅ Refresco completo ejecutado. Verifica con ./scripts/09-check-status.sh"

