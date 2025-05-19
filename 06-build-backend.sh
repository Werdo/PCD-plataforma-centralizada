#!/bin/bash

# Script: 06-build-backend.sh
# Construye imágenes Docker del backend de la plataforma (servicios core)

set -e

BASE_DIR="/home/ppelaez/plataforma-centralizada/backend"
declare -A SERVICES=(
  ["api-rest"]="backend-api:latest"
  ["websocket"]="backend-websocket:latest"
  ["alerts"]="backend-alerts:latest"
)

echo "🔧 Iniciando construcción de imágenes Docker para microservicios backend..."

for SERVICE in "${!SERVICES[@]}"; do
  DIR="$BASE_DIR/$SERVICE"
  IMAGE="${SERVICES[$SERVICE]}"

  echo "📦 Construyendo $SERVICE → imagen: $IMAGE"

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

echo "🎉 Todas las imágenes del backend han sido construidas correctamente."

