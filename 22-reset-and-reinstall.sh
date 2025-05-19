#!/bin/bash

# Script: 22-reset-and-reinstall.sh
# Limpia todo el entorno excepto scripts y vuelve a desplegar todo desde cero

set -e

echo "⚠️ Este proceso eliminará el entorno actual y lo reinstalará por completo"
echo "Se mantendrá solo la carpeta /home/ppelaez/scripts"
read -p "¿Deseas continuar? (sí para continuar): " CONFIRM

if [[ "$CONFIRM" != "sí" ]]; then
  echo "❌ Cancelado por el usuario."
  exit 1
fi

# Limpiar entorno
bash /home/ppelaez/scripts/00-clean-environment.sh

# Reiniciar instalación desde cero
bash /home/ppelaez/scripts/01-bootstrap.sh
bash /home/ppelaez/scripts/02-init-cluster.sh
bash /home/ppelaez/scripts/03-sync-manifests.sh
bash /home/ppelaez/scripts/00-prepare-database.sh
bash /home/ppelaez/scripts/04-setup-backend-files.sh
bash /home/ppelaez/scripts/05-prepare-fyr.sh
bash /home/ppelaez/scripts/04-prepare-facit.sh
bash /home/ppelaez/scripts/06-build-backend.sh
bash /home/ppelaez/scripts/07-import-images.sh
bash /home/ppelaez/scripts/21-redeploy-all.sh

# Estado final
bash /home/ppelaez/scripts/20-status-full-report.sh

echo "✅ Plataforma completamente reinstalada y operativa."

