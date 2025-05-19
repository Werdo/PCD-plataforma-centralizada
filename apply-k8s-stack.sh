#!/bin/bash

# Script: apply-k8s-stack.sh
# Aplica el archivo consolidado K8s-deploy-stack.yaml generado por merge-k8s.sh

set -e

STACK_FILE="/home/ppelaez/plataforma-centralizada/k8s/K8s-deploy-stack.yaml"

if [ ! -f "$STACK_FILE" ]; then
  echo "❌ ERROR: No se encontró el archivo $STACK_FILE"
  echo "ℹ️ Ejecuta primero ./scripts/merge-k8s.sh"
  exit 1
fi

echo "☸️ Aplicando manifiesto combinado..."
kubectl apply -f "$STACK_FILE"

echo "✅ Todos los recursos del stack se han aplicado."
echo "📋 Verifica el estado con: kubectl get all -n central-platform"

