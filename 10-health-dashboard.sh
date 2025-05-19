#!/bin/bash

# Script: 10-health-dashboard.sh
# Verifica conectividad de los pods frontend y backend con sus servicios

set -e

NAMESPACE="central-platform"

echo "===================== 🧪 DASHBOARD DE SALUD ====================="

# Frontend -> Backend
echo -e "\n🔌 Verificando conectividad desde los frontends hacia API y WebSocket..."

for POD in $(kubectl get pods -n "$NAMESPACE" -l app in (frontend-facit,frontend-fyr) -o name); do
  echo "👉 Pod: $POD"
  kubectl exec -n "$NAMESPACE" "$POD" -- apk add --no-cache curl >/dev/null 2>&1 || true
  echo -n " - HTTP API: "
  kubectl exec -n "$NAMESPACE" "$POD" -- curl -s -o /dev/null -w "%{http_code}" http://api-rest-service:8000/api/v1/health || echo "NO"
  echo ""
  echo -n " - WebSocket: "
  kubectl exec -n "$NAMESPACE" "$POD" -- sh -c "apk add websocat >/dev/null 2>&1 || true; timeout 3 websocat ws://websocket-service:3000" || echo "❌ No conecta"
done

# Backend -> Bases de datos
echo -e "\n💾 Verificando conectividad desde backend a Redis, PostgreSQL y MongoDB..."

for POD in $(kubectl get pods -n "$NAMESPACE" -l app in (api-rest,websocket,alerts) -o name); do
  echo "👉 Pod: $POD"
  kubectl exec -n "$NAMESPACE" "$POD" -- apk add --no-cache redis-tools postgresql-client mongodb-tools >/dev/null 2>&1 || true

  echo -n " - Redis: "
  kubectl exec -n "$NAMESPACE" "$POD" -- redis-cli -h redis-service ping || echo "❌"

  echo -n " - PostgreSQL: "
  kubectl exec -n "$NAMESPACE" "$POD" -- pg_isready -h postgresql-service -p 5432 -U admin || echo "❌"

  echo -n " - MongoDB: "
  kubectl exec -n "$NAMESPACE" "$POD" -- mongo mongodb-service --eval 'db.runCommand({ ping: 1 })' | grep ok || echo "❌"
done

echo -e "\n✅ Verificación completa."
echo "================================================================="

