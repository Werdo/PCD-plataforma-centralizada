#!/bin/bash

# Script: 04-setup-backend-files.sh
# Copia archivos backend desde scripts/backend-files a plataforma-centralizada/backend manteniendo estructura

set -e

ORIGIN_BASE="/home/ppelaez/scripts/backend-files"
DEST_BASE="/home/ppelaez/plataforma-centralizada/backend"

echo "🔁 Copiando todos los archivos de servicios backend..."

# Servicios core
SERVICES=(
  "api-rest"
  "websocket"
  "alerts"
)

# Gateways
GATEWAYS=(
  "t301-tracking"
  "goodwe-sems"
)

# IA
IA_SERVICES=(
  "openai-proxy"
)

# Función para copiar archivos si existen
copy_service() {
  local SOURCE_DIR="$1"
  local DEST_DIR="$2"
  local NAME="$3"

  echo "📦 Procesando: $NAME"
  if [ -d "$SOURCE_DIR" ]; then
    mkdir -p "$DEST_DIR"
    cp -r "$SOURCE_DIR"/* "$DEST_DIR/"
    echo "✅ Copiado: $SOURCE_DIR → $DEST_DIR"
  else
    echo "⚠️  No encontrado: $SOURCE_DIR"
  fi
}

# Servicios principales
for SERVICE in "${SERVICES[@]}"; do
  copy_service "$ORIGIN_BASE/$SERVICE" "$DEST_BASE/$SERVICE" "$SERVICE"
  if [ ! -f "$DEST_BASE/$SERVICE/main.py" ] || [ ! -f "$DEST_BASE/$SERVICE/Dockerfile" ]; then
    echo "❗ Advertencia: $SERVICE sin main.py o Dockerfile"
  fi
  echo ""
done

# Gateways
for GW in "${GATEWAYS[@]}"; do
  copy_service "$ORIGIN_BASE/gateways/$GW" "$DEST_BASE/gateways/$GW" "$GW"
  echo ""
done

# IA
for IA in "${IA_SERVICES[@]}"; do
  copy_service "$ORIGIN_BASE/ia/$IA" "$DEST_BASE/ia/$IA" "$IA"
  echo ""
done

echo "✅ Todos los archivos backend han sido copiados correctamente."
echo "📂 Carpeta destino: $DEST_BASE"

