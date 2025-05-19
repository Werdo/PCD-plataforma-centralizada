#!/bin/bash

# Script: 21-redeploy-all.sh
# Ejecuta merge de manifiestos, aplica el stack consolidado y hace rollout de todos los deployments

set -e

MERGE_SCRIPT="/home/ppelaez/scripts/merge-k8s.sh"
APPLY_SCRIPT="/home/ppelaez/scripts/apply-k8s-stack.sh"
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
  passbolt
  rustdesk-server
)

echo "🔁 Ejecutando merge de manifiestos..."
bash "$MERGE_SCRIPT"

echo "☸️ Aplicando manifiesto combinado..."
bash "$APPLY_SCRIPT"

echo "🔁 Reiniciando deployments..."
for DEP in "${DEPLOYMENTS[@]}"; do
  echo "↪️ Rollout: $DEP"
  kubectl rollout restart deployment "$DEP" -n "$NAMESPACE"
done

echo "✅ Despliegue completo relanzado. Verifica con ./scripts/20-status-full-report.sh"

