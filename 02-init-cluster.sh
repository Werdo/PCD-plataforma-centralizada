#!/bin/bash

# Script: 02-init-cluster.sh
# Instala K3s y configura acceso externo mediante NGINX Ingress

set -e

NAMESPACE="central-platform"
KUBECONFIG_PATH="/home/ppelaez/.kube/config"

echo "🚀 Instalando K3s (Kubernetes lightweight)..."
curl -sfL https://get.k3s.io | sh -

echo "🔐 Configurando acceso kubectl para el usuario..."
mkdir -p $(dirname "$KUBECONFIG_PATH")
sudo cp /etc/rancher/k3s/k3s.yaml "$KUBECONFIG_PATH"
sudo chown -R ppelaez:ppelaez /home/ppelaez/.kube
export KUBECONFIG="$KUBECONFIG_PATH"

# Añadir export permanente
if ! grep -q "KUBECONFIG=" /home/ppelaez/.bashrc; then
  echo "export KUBECONFIG=$KUBECONFIG_PATH" >> /home/ppelaez/.bashrc
fi

echo "⏳ Esperando a que el clúster esté listo..."
sleep 10
kubectl get nodes

echo "📁 Creando namespace base: $NAMESPACE"
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "🌐 Instalando NGINX Ingress Controller (bare-metal)..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml
sleep 10

echo "🔧 Convirtiendo servicio de Ingress a NodePort..."
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "NodePort"}}'

echo "✅ Clúster K3s configurado correctamente con Ingress externo disponible."
echo "ℹ️ Accede desde fuera a través de: http://<IP>:30080 una vez desplegado el stack."
echo "👉 Siguiente paso: ./scripts/03-sync-manifests.sh"

