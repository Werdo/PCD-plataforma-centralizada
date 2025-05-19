#!/bin/bash

# Script: 20-status-full-report.sh
# Muestra un informe completo del estado de la plataforma en Kubernetes

set -e

NAMESPACE="central-platform"

echo "====================== 🌐 ESTADO GENERAL ======================"

echo -e "\n🧠 Nodo(s):"
kubectl get nodes -o wide

echo -e "\n📦 Pods:"
kubectl get pods -n "$NAMESPACE" -o wide

echo -e "\n🔌 Servicios:"
kubectl get svc -n "$NAMESPACE"

echo -e "\n🌐 Ingress:"
kubectl get ingress -n "$NAMESPACE"

echo -e "\n📦 Deployments:"
kubectl get deployments -n "$NAMESPACE"

echo -e "\n🔍 Eventos críticos recientes:"
kubectl get events -n "$NAMESPACE" --sort-by=.lastTimestamp | grep -E 'Warning|Error' || echo "✔️ Sin errores recientes"

echo -e "\n📤 Exportando YAML de estado del clúster (opcional):"
kubectl get all -n "$NAMESPACE" -o yaml > "/home/ppelaez/status-central-platform.yaml"
echo "📄 Guardado en /home/ppelaez/status-central-platform.yaml"

echo -e "\n✅ Estado completo verificado."
echo "==============================================================="

