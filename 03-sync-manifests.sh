#!/bin/bash

# Script: 03-sync-manifests.sh
# Copia manifiestos YAML desde /scripts a /plataforma-centralizada/k8s/ y los aplica modularmente

set -e

SRC_DIR="/home/ppelaez/scripts"
DST_DIR="/home/ppelaez/plataforma-centralizada/k8s"
NAMESPACE="central-platform"

echo "📁 Creando estructura de manifiestos..."
mkdir -p "$DST_DIR/frontend/admin"
mkdir -p "$DST_DIR/frontend/app"
mkdir -p "$DST_DIR/backend"
mkdir -p "$DST_DIR/gateways"
mkdir -p "$DST_DIR/ia"
mkdir -p "$DST_DIR/tools"
mkdir -p "$DST_DIR/ingress"
mkdir -p "$DST_DIR/databases"

# Copiar YAMLs si existen
copy_if_exists() {
  if [ -f "$1" ]; then
    cp "$1" "$2"
    echo "✅ Copiado: $(basename "$1") → $2"
  else
    echo "⚠️  No encontrado: $(basename "$1")"
  fi
}

echo "📦 Copiando manifiestos de frontend..."
copy_if_exists "$SRC_DIR/frontend-facit.yaml" "$DST_DIR/frontend/admin/"
copy_if_exists "$SRC_DIR/frontend-fyr.yaml" "$DST_DIR/frontend/app/"

echo "📦 Copiando manifiestos de backend..."
copy_if_exists "$SRC_DIR/api-rest.yaml" "$DST_DIR/backend/"
copy_if_exists "$SRC_DIR/websocket.yaml" "$DST_DIR/backend/"
copy_if_exists "$SRC_DIR/alerts.yaml" "$DST_DIR/backend/"

echo "📦 Copiando gateways..."
copy_if_exists "$SRC_DIR/gateway-t301.yaml" "$DST_DIR/gateways/"
copy_if_exists "$SRC_DIR/gateway-goodwe.yaml" "$DST_DIR/gateways/"

echo "📦 Copiando IA..."
copy_if_exists "$SRC_DIR/gateway-openai.yaml" "$DST_DIR/ia/"

echo "📦 Copiando herramientas internas (passbolt + rustdesk)..."
copy_if_exists "$SRC_DIR/passbolt-rustdesk.yaml" "$DST_DIR/tools/"

echo "📦 Copiando ingress..."
copy_if_exists "$SRC_DIR/ingress.yaml" "$DST_DIR/ingress/"

echo "📦 Copiando stack consolidado si existe..."
if [ -f "$SRC_DIR/K8s-deploy-stack.yaml" ]; then
  cp "$SRC_DIR/K8s-deploy-stack.yaml" "$DST_DIR/"
  echo "✅ Copiado: K8s-deploy-stack.yaml"
elif [ -f "$SRC_DIR/K8s-deploy-stack" ]; then
  cp "$SRC_DIR/K8s-deploy-stack" "$DST_DIR/K8s-deploy-stack.yaml"
  echo "✅ Copiado: K8s-deploy-stack (renombrado)"
fi

echo ""
echo "☸️ Aplicando manifiestos por carpeta (modular)..."

for CATEGORY in frontend backend gateways ia tools ingress databases; do
  SUBDIR="$DST_DIR/$CATEGORY"
  if [ -d "$SUBDIR" ]; then
    echo "📂 Procesando: $CATEGORY"
    for FILE in "$SUBDIR"/*.yaml; do
      [ -f "$FILE" ] || continue
      echo "   ↪ Aplicando: $(basename "$FILE")"
      kubectl apply -f "$FILE" || echo "❌ Error aplicando $FILE"
    done
  fi
  echo ""
done

echo "✅ Todos los manifiestos individuales han sido aplicados correctamente."

