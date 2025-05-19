
#!/bin/bash

# Script: 14-deploy-gateway-goodwe.sh
# Construye, importa y despliega el microservicio GoodWe desde su ruta definitiva

set -e

NAME="gateway-goodwe"
DIR="/home/ppelaez/plataforma-centralizada/backend/gateways/goodwe-sems"
YAML="/home/ppelaez/plataforma-centralizada/k8s/gateways/gateway-goodwe.yaml"
IMAGE="$NAME:latest"
NAMESPACE="central-platform"
TAR="$DIR/$NAME.tar"

echo "🚧 [1/5] Verificando archivos necesarios..."

if [ ! -f "$DIR/Dockerfile" ] || [ ! -f "$DIR/main.py" ]; then
  echo "❌ ERROR: Faltan archivos necesarios en $DIR"
  exit 1
fi

echo "🐳 [2/5] Construyendo imagen Docker: $IMAGE"
docker build -t "$IMAGE" "$DIR"

echo "📦 [3/5] Exportando imagen..."
docker save "$IMAGE" -o "$TAR"

echo "📥 [4/5] Importando en containerd (K3s)..."
sudo k3s ctr images import "$TAR"

echo "☸️ [5/5] Desplegando en Kubernetes desde manifiesto..."
kubectl apply -f "$YAML"

echo "⏳ Esperando disponibilidad del deployment..."
kubectl rollout status deployment "$NAME" -n "$NAMESPACE" --timeout=180s || {
  echo "⚠️ Timeout alcanzado. Mostrando estado del pod..."
  POD=$(kubectl get pods -n "$NAMESPACE" -l app=$NAME -o jsonpath='{.items[0].metadata.name}')
  kubectl describe pod "$POD" -n "$NAMESPACE"
  kubectl logs "$POD" -n "$NAMESPACE"
}

