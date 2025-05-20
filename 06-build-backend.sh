#!/bin/bash

# Script: 06-build-backend.sh
# Construye todas las imágenes Docker necesarias para la plataforma

set -e

BASE_DIR="/home/ppelaez/plataforma-centralizada"

# Mapa de carpetas relativas → nombre de imagen
declare -A SERVICES=(
  ["frontend/admin"]="frontend:latest"
  ["frontend/app"]="frontend-fyr:latest"
  ["backend/api-rest"]="backend-api:latest"
  ["backend/websocket"]="backend-websocket:latest"
  ["backend/alerts"]="backend-alerts:latest"
  ["backend/gateways/t301-tracking"]="gateway-t301:latest"
  ["backend/gateways/goodwe-sems"]="gateway-goodwe:latest"
  ["backend/ia/openai-proxy"]="openai-proxy:latest"
)

echo "🔧 Iniciando construcción de imágenes Docker para todos los servicios..."

for REL_DIR in "${!SERVICES[@]}"; do
  DIR="$BASE_DIR/$REL_DIR"
  IMAGE="${SERVICES[$REL_DIR]}"

  echo "📦 Construyendo $REL_DIR → imagen: $IMAGE"

  if [ ! -d "$DIR" ]; then
    echo "❌ ERROR: Carpeta no encontrada: $DIR"
    continue
  fi

  if [ ! -f "$DIR/Dockerfile" ]; then
    echo "❌ ERROR: No se encontró Dockerfile en $DIR"
    continue
  fi

  if [ ! -f "$DIR/main.py" ]; then
    echo "⚠️ Advertencia: main.py no encontrado en $DIR (puede no ser necesario)"
  fi

  docker build -t "$IMAGE" "$DIR" && echo "✅ Imagen creada: $IMAGE"
  echo ""
done

echo "🎉 Todas las imágenes han sido construidas correctamente."

