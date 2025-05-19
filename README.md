# Plataforma Centralizada de Información - Guía de Despliegue Completo

Este sistema permite desplegar una plataforma compuesta por microservicios backend, dos frontends, bases de datos, servicios de utilidad internos y posibilidad de conexión futura con IA on-premise, todo gestionado sobre K3s y accesible desde el exterior.

---

## 🧱 Requisitos del sistema
- Ubuntu 24.04
- Acceso sudo
- Red con salida a internet
- Puertos abiertos: 30080, 21115–21118 (RustDesk), 80 (HTTP Ingress)

---

## 📂 Estructura esperada
```
/home/ppelaez/
├── scripts/
├── backups/
├── plataforma-centralizada/
│   ├── frontend/
│   │   ├── admin/           → Facit
│   │   └── app/             → FYR
│   ├── backend/
│   │   ├── api-rest/
│   │   ├── websocket/
│   │   └── alerts/
│   └── k8s/
│       ├── frontend/admin/
│       ├── frontend/app/
│       ├── backend/
│       ├── databases/
│       ├── ingress/
│       ├── tools/           → passbolt-rustdesk.yaml
│       └── K8s-deploy-stack.yaml
```

---

## 🚀 Pasos de despliegue

### 1. 🔧 Preparación base
```bash
./scripts/01-bootstrap.sh
```
> Instala Node.js, Docker, kubectl, Helm, dependencias y carpetas.

### 2. ☸️ Instalación de clúster K3s
```bash
./scripts/02-init-cluster.sh
```
> Instala K3s, configura kubectl y despliega NGINX Ingress.

### 3. 📁 Sincronización de manifiestos
```bash
./scripts/03-sync-manifests.sh
```
> Copia los YAML a sus rutas correspondientes dentro de `k8s/`.

### 4. ⚙️ Preparación de servicios
```bash
./scripts/04-prepare-facit.sh
./scripts/05-prepare-fyr.sh
./scripts/06-build-backend.sh
```

### 5. 🐳 Importación de imágenes a containerd (K3s)
```bash
./scripts/07-import-images.sh
```

### 6. 🚀 Despliegue de toda la plataforma
```bash
./scripts/08-deploy-full-stack.sh
```

### 7. ✅ Verificación
```bash
./scripts/09-check-status.sh
./scripts/10-health-dashboard.sh
```

### 8. 🛠 Despliegue de herramientas internas (Passbolt + RustDesk)
```bash
./scripts/12-deploy-tools.sh
```

---

## 🌐 Accesos públicos (IP externa)
```
http://<IP>:30080/admin           → Facit (admin panel)
http://<IP>:30080/app             → FYR (IA pública)
http://<IP>:30080/api             → API REST
ws://<IP>:30080/ws                → WebSocket
http://passbolt.emiliomoro.local  → Passbolt
http://rustdesk.emiliomoro.local  → RustDesk Web
```

---

## 🧭 Menú de administración
```bash
./scripts/11-cluster-admin.sh
```
> Despliegue, reinicio, logs, backups, estado y rollout backend.

---

## 🧠 Servicios planificados (próximos pasos)
- Gateways de integración externa
- Conexión a IA on-premise
- Certificados TLS automáticos con cert-manager (si se usa dominio)
- Panel web de monitorización vía Grafana/Prometheus

---

## 🧼 Tips y recomendaciones
- Reinicia sesión tras ejecutar `01-bootstrap.sh`
- Si ves `ImagePullBackOff`, ejecuta `07-import-images.sh`
- Usa `11-cluster-admin.sh` como panel de control principal
- Personaliza los valores de entorno (`.env`, variables) según tu infraestructura

---

Plataforma robusta, modular, accesible y preparada para escalar. 100% autoalojada.

---
## Update Gateway and Tools
# Plataforma Centralizada de Información - README Actualizado

Este sistema orquestado sobre Kubernetes incluye microservicios backend, frontends independientes, bases de datos, pasarelas externas y servicios de infraestructura para despliegue completo y robusto.

---

## 🔧 NUEVAS FUNCIONALIDADES INTEGRADAS

### 📡 Gateways desarrollados

- **gateway-t301**: receptor TCP para dispositivos de geolocalización de vehículos (protocolo T301)
- **gateway-goodwe**: conexión a la API SEMS de GoodWe para consultar generación solar
- (estructura base prevista): gateway Datawine, SIGENA, Schneider, Odoo

### 🤖 Servicios de Inteligencia Artificial

- **openai-proxy**: microservicio FastAPI que permite que FYR consulte ChatGPT mediante un backend controlado
- (pendiente): **deepseek-onprem**: servicio IA localizable que se conectará a un modelo on-premise futuro

### 🔐 Servicios de utilidad desplegados

- **Passbolt**: gestor de contraseñas en contenedor desplegado vía YAML, con ingress y conexión a PostgreSQL
- **RustDesk Server**: contenedor con relay + rendezvous, interfaz web expuesta por ingress, para asistencia remota

---

## 🧱 Organización por carpetas

```
/scripts/backend-files/
├── api-rest/
├── websocket/
├── alerts/
├── gateways/
│   ├── t301/
│   └── goodwe/
└── ia/
    └── openai-proxy/
```

Cada microservicio tiene su `main.py`, `Dockerfile`, `requirements.txt` y manifiesto K8s.

---

## 🛠️ Scripts nuevos clave

| Script                             | Función                                                  |
|------------------------------------|-----------------------------------------------------------|
| 13-deploy-gateway-t301.sh         | Despliegue completo del gateway TCP T301                 |
| 14-deploy-gateway-goodwe.sh       | Despliegue completo del microservicio GoodWe SEMS       |
| 15-deploy-openai-proxy.sh         | Despliegue completo del microservicio IA via OpenAI     |
| 04-setup-backend-files.sh         | Copia los ficheros del backend a su ruta definitiva      |

---

## 🌐 Accesos adicionales habilitados

- `http://passbolt.emiliomoro.local` → gestor de contraseñas
- `http://rustdesk.emiliomoro.local` → interfaz remota del servidor RustDesk
- `http://<IP>:30080/ask` (vía proxy IA OpenAI)

---

## 📦 Pendientes por desplegar o integrar

- IA on-premise (`deepseek-onprem`): definir motor y despliegue base
- Gateways: Datawine, SIGENA, Schneider, conexión Odoo
- Cert-manager e ingress TLS
- Exportación masiva de datos desde los gateways a la plataforma

---

# 1. Preparar entorno base
./scripts/01-bootstrap.sh

# 2. Instalar K3s + Ingress + namespace
./scripts/02-init-cluster.sh

# 3. Sincronizar manifiestos de Kubernetes
./scripts/03-sync-manifests.sh

# 4. Copiar los archivos backend al sitio final
./scripts/04-setup-backend-files.sh

# 5. Preparar frontends
./scripts/04-prepare-facit.sh
./scripts/05-prepare-fyr.sh

# 6. Construir backend desde carpetas definitivas
./scripts/06-build-backend.sh

# 7. Importar imágenes construidas en K3s
./scripts/07-import-images.sh

# 8. Desplegar servicios principales (frontend, backend, DBs, Ingress)
./scripts/08-deploy-full-stack.sh

# 9. Verificar estado general
./scripts/09-check-status.sh
./scripts/10-health-dashboard.sh

# 10. Desplegar servicios internos (Passbolt + RustDesk)
./scripts/12-deploy-tools.sh

# 11. Desplegar gateways o IA según necesidad
./scripts/13-deploy-gateway-t301.sh
./scripts/14-deploy-gateway-goodwe.sh
./scripts/15-deploy-openai-proxy.sh
