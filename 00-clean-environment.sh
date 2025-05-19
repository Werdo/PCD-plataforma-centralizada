#!/bin/bash

# Script: 00-clean-environment.sh
# Elimina por completo la plataforma excepto la carpeta scripts

set -e

echo "⚠️ Este script eliminará completamente:"
echo " - Todos los recursos de Kubernetes en el namespace 'central-platform'"
echo " - Todas las carpetas de trabajo de /home/ppelaez/ excepto /scripts/"
read -p "¿Estás seguro? (sí para continuar): " CONFIRM

if [[ "$CONFIRM" != "sí" ]]; then
  echo "❌ Cancelado por el usuario."
  exit 1
fi

echo "☸️ Eliminando namespace 'central-platform'..."
kubectl delete namespace central-platform --ignore-not-found=true

echo "📂 Borrando todo en /home/ppelaez excepto /scripts..."
cd /home/ppelaez
for DIR in *; do
  if [[ "$DIR" != "scripts" ]]; then
    echo "🗑️ Eliminando: $DIR"
    sudo rm -rf "$DIR"
  fi
done

echo "🐳 Eliminando imágenes Docker locales relacionadas..."
docker rmi -f \
  frontend:latest \
  frontend-fyr:latest \
  backend-api:latest \
  backend-websocket:latest \
  backend-alerts:latest \
  gateway-t301:latest \
  gateway-goodwe:latest \
  openai-proxy:latest 2>/dev/null || true

echo "🧼 Limpieza finalizada."
echo "✅ Sistema listo para comenzar instalación desde cero."

