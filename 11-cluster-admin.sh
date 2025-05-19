#!/bin/bash

# Script: 11-cluster-admin.sh
# Menú interactivo para administrar el clúster completo de forma centralizada

NAMESPACE="central-platform"
STACK_FILE="/home/ppelaez/plataforma-centralizada/k8s/K8s-deploy-stack.yaml"

function desplegar_stack() {
  ./scripts/08-deploy-full-stack.sh
}

function reiniciar_pods() {
  echo "🔁 Reiniciando todos los pods..."
  kubectl delete pods --all -n "$NAMESPACE"
}

function eliminar_todo() {
  echo "🧹 Eliminando todos los recursos definidos..."
  kubectl delete -f "$STACK_FILE"
}

function iniciar_manual() {
  echo "🚀 Aplicando manifiestos manualmente..."
  kubectl apply -f "$STACK_FILE"
}

function comprobar_estado() {
  ./scripts/09-check-status.sh
}

function ver_dashboard() {
  ./scripts/10-health-dashboard.sh
}

function ver_logs() {
  echo "📝 Logs recientes por pod:"
  for POD in $(kubectl get pods -n "$NAMESPACE" -o name); do
    echo "---- $POD ----"
    kubectl logs -n "$NAMESPACE" "$POD" --tail=20
  done
}

function backup_postgres() {
  echo "🗃️ Backup de PostgreSQL..."
  mkdir -p /home/ppelaez/backups
  kubectl exec -n "$NAMESPACE" deploy/postgresql -- \
    pg_dump -U admin centraldb > "/home/ppelaez/backups/postgres-$(date +%Y%m%d-%H%M).sql"
  echo "✅ Backup guardado en /home/ppelaez/backups"
}

function rollout_backend() {
  echo "♻️ Reiniciando backend..."
  for dep in api-rest websocket alerts; do
    kubectl rollout restart deployment "$dep" -n "$NAMESPACE"
  done
}

while true; do
  echo ""
  echo "========= MENÚ DE ADMINISTRACIÓN ========="
  echo "1) 📦 Desplegar stack completo"
  echo "2) 🔁 Reiniciar todos los pods"
  echo "3) 🧹 Eliminar todos los recursos"
  echo "4) 🚀 Aplicar stack manualmente"
  echo "5) 🧪 Ver estado general"
  echo "6) 🔍 Ver dashboard de salud"
  echo "7) 📝 Ver logs recientes"
  echo "8) 🗃️ Backup de PostgreSQL"
  echo "9) ♻️ Rollout backend"
  echo "0) ❌ Salir"
  echo "=========================================="
  read -p "Selecciona una opción: " OPC

  case $OPC in
    1) desplegar_stack ;;
    2) reiniciar_pods ;;
    3) eliminar_todo ;;
    4) iniciar_manual ;;
    5) comprobar_estado ;;
    6) ver_dashboard ;;
    7) ver_logs ;;
    8) backup_postgres ;;
    9) rollout_backend ;;
    0) echo "👋 Saliendo..."; exit 0 ;;
    *) echo "❌ Opción no válida." ;;
  esac
done

