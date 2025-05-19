#!/bin/bash

# Script: 01-bootstrap.sh
# Instala todas las dependencias necesarias sin configurar clúster ni desplegar servicios

set -e

echo "🔧 Iniciando instalación de entorno base para Plataforma Centralizada..."

# =========================
# 1. Crear estructura de carpetas
# =========================
echo "📁 Creando estructura base..."
mkdir -p /home/ppelaez/{scripts,backups,logs,plantillas,tmp-facit,tmp-fyr}
mkdir -p /home/ppelaez/plataforma-centralizada/{frontend/admin,frontend/app,backend/api-rest,backend/websocket,backend/alerts}
mkdir -p /home/ppelaez/plataforma-centralizada/k8s/{frontend/admin,frontend/app,backend,databases,ingress,external,tools}
mkdir -p /home/ppelaez/plataforma-centralizada/config

# =========================
# 2. Actualizar sistema
# =========================
echo "🔄 Actualizando paquetes del sistema..."
sudo apt update && sudo apt upgrade -y

# =========================
# 3. Instalar utilidades base
# =========================
echo "🧰 Instalando herramientas básicas..."
sudo apt install -y unzip curl git rsync ca-certificates gnupg lsb-release mailutils software-properties-common

# =========================
# 4. Instalar Node.js 20 + npm
# =========================
echo "🟢 Instalando Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# =========================
# 5. Instalar Docker y Docker Compose plugin
# =========================
echo "🐳 Instalando Docker..."
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER
mkdir -p ~/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# =========================
# 6. Instalar kubectl y Helm
# =========================
echo "☸️ Instalando kubectl y Helm..."
KUBECTL_VERSION="v1.29.2"
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# =========================
# 7. Mensaje final
# =========================
echo ""
echo "✅ Entorno base instalado correctamente."
echo "📌 Cierra sesión o ejecuta 'newgrp docker' para aplicar el grupo docker."
echo "🧭 A continuación ejecuta:"
echo "     ./scripts/02-init-cluster.sh"

