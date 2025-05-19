# 📦 README - Despliegues Modulares de Gateways y Servicios IA

Este documento recoge los comandos de despliegue individuales para gateways y servicios IA, ya integrados modularmente en la plataforma.

---

## 🧭 Rutas definitivas

Los servicios viven en:
```
/plataforma-centralizada/backend/gateways/<servicio>/
/plataforma-centralizada/backend/ia/<servicio>/
```

Los manifiestos viven en:
```
/plataforma-centralizada/k8s/gateways/
/plataforma-centralizada/k8s/ia/
```

---

## 🚀 Despliegue por servicio

### 🔹 T301 Tracking Gateway
```bash
./scripts/13-deploy-gateway-t301.sh
```
- Construye desde: `/backend/gateways/t301-tracking/`
- Aplica: `/k8s/gateways/gateway-t301.yaml`

### 🔹 GoodWe SEMS API Gateway
```bash
./scripts/14-deploy-gateway-goodwe.sh
```
- Construye desde: `/backend/gateways/goodwe/`
- Aplica: `/k8s/gateways/gateway-goodwe.yaml`

### 🔹 Proxy OpenAI (IA externa temporal)
```bash
./scripts/15-deploy-openai-proxy.sh
```
- Construye desde: `/backend/ia/openai-proxy/`
- Aplica: `/k8s/ia/gateway-openai.yaml`

---

## 🛠 Tips de depuración

```bash
kubectl get pods -n central-platform
kubectl describe pod <nombre> -n central-platform
kubectl logs <nombre> -n central-platform
```

Si ves: `deployment exceeded its progress deadline`:
1. Verifica que los archivos estén bien copiados
2. Reejecuta `04-setup-backend-files.sh` si hace falta
3. Reintenta el script del servicio

---

## 📍 Recordatorio

- Todos los scripts usan rutas **reales y definitivas**
- Las imágenes se exportan e importan automáticamente en `containerd`
- Cada manifiesto está separado por función y se sincroniza con:
```bash
./scripts/03-sync-manifests.sh
```

---

Despliegue modular y extensible para nuevos gateways e integraciones futuras.

