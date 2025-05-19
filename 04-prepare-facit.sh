#!/bin/bash

# Script: 04-prepare-facit.sh
# Descomprime, instala y empaqueta la plantilla FACIT en Docker

set -e

ZIP_PATH="/home/ppelaez/scripts/facit/facit-vite.zip"
TMP_DIR="/home/ppelaez/scripts/tmp-facit"
TARGET_DIR="/home/ppelaez/plataforma-centralizada/frontend/admin"
IMAGE_NAME="frontend:latest"

echo "🔧 [1/8] Verificando ZIP..."
if [ ! -f "$ZIP_PATH" ]; then
    echo "❌ No se encontró el ZIP en $ZIP_PATH"
    exit 1
fi

echo "🧹 [2/8] Limpiando carpetas temporales y destino..."
rm -rf "$TMP_DIR" "$TARGET_DIR"
mkdir -p "$TMP_DIR" "$TARGET_DIR"

echo "📦 [3/8] Descomprimiendo plantilla FACIT..."
unzip -q "$ZIP_PATH" -d "$TMP_DIR"

echo "🔍 [4/8] Buscando package.json..."
PROJECT_DIR=$(find "$TMP_DIR" -name package.json -exec dirname {} \; | head -n 1)
if [ -z "$PROJECT_DIR" ]; then
    echo "❌ No se encontró un proyecto React válido"
    exit 1
fi

echo "📂 Copiando contenido a: $TARGET_DIR"
rsync -a "$PROJECT_DIR/" "$TARGET_DIR/"

echo "📦 [5/8] Instalando dependencias..."
cd "$TARGET_DIR"
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
npm install --save-dev rollup@2.79.1

echo "🐳 [6/8] Generando Dockerfile..."
cat > "$TARGET_DIR/Dockerfile" <<EOF
FROM node:20-slim as builder
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y python3 make g++ \\
 && npm install --legacy-peer-deps \\
 && npm install --save-dev rollup@2.79.1 \\
 && npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

echo "🚀 [7/8] Construyendo imagen Docker: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .

echo "✅ [8/8] Imagen Docker 'frontend:latest' lista."

