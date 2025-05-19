#!/bin/bash

# Script: 07-import-images.sh
# Exporta e importa imágenes Docker en el runtime containerd de K3s

set -e

IMAGES=(
  frontend:latest
  frontend-fyr:latest
  backend-api:latest
  backend-websocket:latest
  backend-alerts:latest
  gateway-t301:latest
  gateway-goodwe:latest
  openai-proxy:latest
)

TMP_DIR="/tmp/k3s-images"
mkdir -p "$TMP_DIR"

echo "📦 Exportando imágenes locales desde Docker..."
for IMAGE in "${IMAGES[@]}"; do
  FILE="$TMP_DIR/$(echo "$IMAGE" | tr '/:' '_').tar"
  echo "  - Guardando $IMAGE → $FILE"
  docker save "$IMAGE" -o "$FILE"
done

echo "📥 Importando imágenes en containerd (K3s)..."
for FILE in "$TMP_DIR"/*.tar; do
  echo "  - Importando $(basename "$FILE")"
  sudo k3s ctr images import "$FILE"
done

echo "✅ Todas las imágenes han sido importadas correctamente en el entorno de K3s."
echo "🔁 Puedes hacer rollout con:"
echo "    kubectl rollout restart deployment -n central-platform"

