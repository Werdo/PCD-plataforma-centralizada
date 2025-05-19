# 🛠️ README - Servicios Internos (Tools)

Este documento recoge todos los servicios internos desplegados dentro de la plataforma, orientados a infraestructura, mantenimiento, asistencia remota y seguridad operativa.

---

## 📂 Carpeta: `k8s/tools/`
Contiene los manifiestos que despliegan:
- Gestores de contraseñas
- Asistentes remotos
- Cualquier servicio que no sea backend funcional ni gateway

---

## 🔐 Passbolt

### Funcionalidad
- Gestor de contraseñas corporativo
- Acceso desde navegador
- Soporta roles, compartición y auditoría

### Despliegue
- Imagen oficial: `passbolt/passbolt:latest-ce`
- Base de datos: PostgreSQL
- Volumen persistente: PVC 2Gi
- Ingress: `http://passbolt.emiliomoro.local`

### Configuración
- Variables de entorno definidas directamente en el deployment
- Pendiente: uso de `ConfigMap` y `Secrets`

---

## 🖥️ RustDesk Server

### Funcionalidad
- Servidor relay + rendezvous para escritorio remoto
- Permite conexión directa sin necesidad de cloud externa
- Compatible con app RustDesk cliente

### Puertos usados
- 21115 (relay)
- 21116 (relay 2)
- 21117 (control)
- 21118 (web interface)

### Despliegue
- Imagen oficial: `rustdesk/rustdesk-server:latest`
- Dos contenedores: `hbbs` y `hbbr`
- Ingress web: `http://rustdesk.emiliomoro.local`

---

## 🛠️ Otras herramientas futuras
- Monitorización (Prometheus, Grafana)
- Cert-Manager para TLS
- PostgreSQL Exporter
- Backup programado diario

---

## Despliegue de tools
```bash
./scripts/12-deploy-tools.sh
```

Manifiesto: `k8s/tools/passbolt-rustdesk.yaml`

---

## Seguridad
- Todos los servicios están aislados en el namespace `central-platform`
- El acceso externo está limitado por Ingress o por IP/port forwarding

---

Servicios esenciales para la administración segura y asistencia a la plataforma.

