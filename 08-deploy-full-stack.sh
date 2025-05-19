#!/bin/bash

# Script: 08-deploy-full-stack.sh
# Aplica el manifiesto consolidado y verifica despliegue sólo si existen todos los componentes

set -e

STACK_FILE="/home/ppelaez/plataforma-centralizada/k8s/K8s-deploy-stack.yaml"
NAMESPACE="central-platform"
DEPLOYMENTS=(
  api-rest
  websocket
  alerts
  frontend-facit
  frontend-fyr
  gateway-t301
  gateway-goodwe
  openai-proxy
)

# Verificar manifiesto
if [ ! -f "$STACK_FILE" ]; then
  echo "❌ ERROR: No se encuentra el manifiesto $STACK_FILE"
  exit 1
fi

# Validar que los deployments existen (asumimos que se aplicaron antes con 03)
for DEP in "${DEPLOYMENTS[@]}"; do
  if ! kubectl get deployment "$DEP" -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "❌ ERROR: No se encontró el deployment $DEP en el namespace $NAMESPACE"
    echo "ℹ️ Ejecuta ./scripts/03-sync-manifests.sh para aplicar los manifiestos individuales."
    exit 1
  fi
done

echo "🚀 Despliegue completo de la plataforma centralizada"
echo "📦 Aplicando stack..."
kubectl apply -f "$STACK_FILE"

echo "⏳ Esperando disponibilidad de los servicios..."
for DEP in "${DEPLOYMENTS[@]}"; do
  echo "⌛ Esperando: $DEP"
  if kubectl rollout status deployment "$DEP" -n "$NAMESPACE" --timeout=180s; then
    echo "✅ $DEP desplegado correctamente"
  else
    echo "⚠️  $DEP no listo a tiempo"
  fi
  echo ""
done

# Obtener IP pública externa
IP=$(curl -s ifconfig.me)
if [[ -z "$IP" ]]; then
  IP=$(hostname -I | awk '{print $1}')
  echo "⚠️ No se pudo obtener IP pública. Usando IP local: $IP"
else
  echo "🌐 IP pública detectada: $IP"
fi

# Mostrar accesos principales
echo "✅ Despliegue completado. Accesos disponibles:"
echo "   http://$IP:30080/admin     → Facit (admin)"
echo "   http://$IP:30080/app       → Fyr (IA pública)"
echo "   http://$IP:30080/api       → API REST"
echo "   ws://$IP:30080/ws          → WebSocket backend"

