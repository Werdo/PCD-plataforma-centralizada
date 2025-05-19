#!/bin/bash

# Script: merge-k8s.sh
# Fusiona todos los manifiestos individuales de la plataforma en un único stack K8s-deploy-stack.yaml

set -e

OUTPUT="/home/ppelaez/plataforma-centralizada/k8s/K8s-deploy-stack.yaml"
BASE="/home/ppelaez/plataforma-centralizada/k8s"

# Encabezado inicial con Namespace
cat <<EOF > "$OUTPUT"
apiVersion: v1
kind: Namespace
metadata:
  name: central-platform
EOF

echo -e "\n---" >> "$OUTPUT"

# Fusionar manifiestos por categoría
for DIR in frontend/backend gateways ia tools ingress databases; do
  SUBDIR="$BASE/$DIR"
  if [ -d "$SUBDIR" ]; then
    echo "📁 Añadiendo manifiestos desde: $SUBDIR"
    for FILE in "$SUBDIR"/*.yaml; do
      [ -f "$FILE" ] || continue
      echo -e "\n---" >> "$OUTPUT"
      cat "$FILE" >> "$OUTPUT"
    done
  fi
done

echo "✅ Archivo combinado generado: $OUTPUT"

