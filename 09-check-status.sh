#!/bin/bash

# Script: 09-check-status.sh
# Muestra el estado de los pods, servicios e ingress tras el despliegue

set -e

NAMESPACE="central-platform"

echo "====================== 🌐 ESTADO GENERAL ======================"

echo -e "\n🧠 Nodo:"
kubectl get nodes -o wide

echo -e "\n📦 Pods:"
kubectl get pods -n "$NAMESPACE"

echo -e "\n🔌 Servicios:"
kubectl get svc -n "$NAMESPACE"

echo -e "\n🌐 Ingress:"
kubectl get ingress -n "$NAMESPACE"

IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
echo -e "\n🌍 Accesos disponibles:"
echo "   http://$IP:30080/admin     → Facit (admin)"
echo "   http://$IP:30080/app       → Fyr (IA pública)"
echo "   http://$IP:30080/api       → API REST"
echo "   ws://$IP:30080/ws          → WebSocket backend"

echo -e "\n⚠️ Eventos críticos recientes:"
kubectl get events -n "$NAMESPACE" --sort-by=.metadata.creationTimestamp | grep -E 'Warning|Error' || echo "Sin errores recientes"

echo "==============================================================="

