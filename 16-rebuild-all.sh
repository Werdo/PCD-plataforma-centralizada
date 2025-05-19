#!/bin/bash

# Script: 16-rebuild-all.sh
# Reconstruye imágenes Docker de frontend, backend, gateways, IA

set -e

KEEP=false
if [[ "$1" == "--keep" ]]; then
  KEEP=true
  echo "🔒 --keep activado: no se eliminarán imágenes previas"
fi

IMAGES=(
  frontend:latest
  frontend-fyr:latest
  backend-api:latest
  backend-websocket:latest
  backend-alerts:latest
  gateway-goodwe:latest
  gateway-t301:latest
  openai-proxy:latest
)

if [ "$KEEP" = false ]; then
  echo "🧹 Eliminando imágenes Docker anteriores..."
  for IMAGE in "${IMAGES[@]}"; do
    docker rmi -f "$IMAGE" 2>/dev/null || true
  done
fi

echo "🔧 Construyendo imágenes..."

docker build -t frontend:latest /home/ppelaez/plataforma-centralizada/frontend/admin
docker build -t frontend-fyr:latest /home/ppelaez/plataforma-centralizada/frontend/app

docker build -t backend-api:latest /home/ppelaez/plataforma-centralizada/backend/api-rest
docker build -t backend-websocket:latest /home/ppelaez/plataforma-centralizada/backend/websocket
docker build -t backend-alerts:latest /home/ppelaez/plataforma-centralizada/backend/alerts

docker build -t gateway-goodwe:latest /home/ppelaez/plataforma-centralizada/backend/gateways/goodwe
docker build -t gateway-t301:latest /home/ppelaez/plataforma-centralizada/backend/gateways/t301-tracking

docker build -t openai-proxy:latest /home/ppelaez/plataforma-centralizada/backend/ia/openai-proxy

echo "✅ Reconstrucción finalizada."

