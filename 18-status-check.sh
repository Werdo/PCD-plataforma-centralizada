#!/bin/bash

# Script: 18-status-check.sh
# Revisa estado de deployments y permite gestionar pods problemáticos

NAMESPACE="central-platform"

function listar_deployments() {
  echo "🧩 Estado de deployments:"
  kubectl get deployments -n "$NAMESPACE" -o custom-columns="NAME:.metadata.name,READY:.status.readyReplicas/1,DESIRED:.status.replicas" --no-headers
}

function listar_pods() {
  echo "📦 Lista de pods:"
  kubectl get pods -n "$NAMESPACE"
}

function logs_pod() {
  read -p "📝 Nombre del pod para ver logs: " POD
  kubectl logs "$POD" -n "$NAMESPACE"
}

function eliminar_pod() {
  read -p "🗑️ Nombre del pod a eliminar: " POD
  kubectl delete pod "$POD" -n "$NAMESPACE"
}

function restart_deployment() {
  read -p "🔁 Nombre del deployment a reiniciar: " DEP
  kubectl rollout restart deployment "$DEP" -n "$NAMESPACE"
}

function describe_pod() {
  read -p "🔎 Nombre del pod para 'describe': " POD
  kubectl describe pod "$POD" -n "$NAMESPACE"
}

while true; do
  echo ""
  echo "========= GESTOR DE ESTADO - $NAMESPACE ========="
  echo "1) 🔍 Ver estado de deployments"
  echo "2) 📋 Ver lista de pods"
  echo "3) 🗑️ Eliminar un pod"
  echo "4) 🔁 Reiniciar un deployment"
  echo "5) 📝 Ver logs de un pod"
  echo "6) 🔎 Ejecutar 'describe' sobre un pod"
  echo "0) ❌ Salir"
  echo "=================================================="
  read -p "Selecciona una opción: " OPC

  case $OPC in
    1) listar_deployments ;;
    2) listar_pods ;;
    3) eliminar_pod ;;
    4) restart_deployment ;;
    5) logs_pod ;;
    6) describe_pod ;;
    0) echo "👋 Saliendo..."; exit 0 ;;
    *) echo "❌ Opción no válida." ;;
  esac
done

