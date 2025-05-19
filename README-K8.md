# 📘 README - Despliegue Modular con Manifiestos Kubernetes

Este archivo documenta el uso del sistema de manifiestos organizados por tipo, usados por `03-sync-manifests.sh` para desplegar los servicios de forma modular, sin depender de un único `K8s-deploy-stack.yaml`.

---

## 🗂️ Estructura de manifiestos `/k8s/`

```
plataforma-centralizada/k8s/
├── frontend/
│   ├── admin/frontend-facit.yaml
│   └── app/frontend-fyr.yaml
├── backend/
│   ├── api-rest.yaml
│   ├── websocket.yaml
│   └── alerts.yaml
├── gateways/
│   ├── gateway-t301.yaml
│   └── gateway-goodwe.yaml
├── ia/
│   └── gateway-openai.yaml
├── tools/
│   └── passbolt-rustdesk.yaml
├── ingress/ingress.yaml
└── K8s-deploy-stack.yaml  ← (opcional)
```

---

## 📦 ¿Qué hace `03-sync-manifests.sh`?

- Copia los `.yaml` desde `/scripts/` a sus carpetas correspondientes en `/k8s/`
- Recorre automáticamente todas las subcarpetas (excepto el consolidado)
- Aplica cada archivo uno por uno con `kubectl apply -f`

### ✅ Ventajas
- Permite aplicar solo una categoría (ej: solo `tools/` o `frontend/app/`)
- Detecta errores individualmente
- Facilita la organización y mantenimiento de manifiestos grandes

---

## 🧭 Comando recomendado

```bash
./scripts/03-sync-manifests.sh
```

> Aplica todos los manifiestos disponibles, excepto `K8s-deploy-stack.yaml`

---

## ✅ Estado final esperado (tras ejecución)

```
kubectl get all -n central-platform
kubectl get ingress -n central-platform
```

Deberías ver tus pods, servicios y controladores desplegados por categoría.

---

## 📌 Notas

- Asegúrate de que los YAML individuales tengan definidos `namespace: central-platform`
- Puedes crear una carpeta nueva dentro de `k8s/` y colocar ahí nuevos manifiestos (por ejemplo: `k8s/monitoring/`)
- Reejecuta el script tras modificar YAMLs para aplicarlos nuevamente

---

Despliegue modular listo para producción y extensible sin dependencias del manifiesto global.

