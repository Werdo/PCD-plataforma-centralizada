# 🛠️ README - Recuperación tras error en despliegue

Este documento explica qué hacer cuando los pods de la plataforma entran en estado `ImagePullBackOff`, `ErrImagePull` o simplemente no arrancan correctamente.

---

## 💥 Causas más comunes

1. El manifiesto de despliegue usa `image: nombre:latest` pero esa imagen **no existe en DockerHub**
2. La imagen sí fue construida localmente, pero **no fue importada a K3s (containerd)**
3. El contenedor arranca pero falla por código o configuración
4. El volumen, base de datos o dependencia no está lista

---

## ✅ Procedimiento de recuperación

### 1️⃣ Recompilar todas las imágenes desde disco local

```bash
./scripts/16-rebuild-all.sh --keep
```
> O sin `--keep` para eliminar versiones anteriores:
> ```bash
> ./scripts/16-rebuild-all.sh
> ```

### 2️⃣ Importar las imágenes en el runtime de K3s

```bash
./scripts/07-import-images.sh
```

### 3️⃣ Reiniciar todos los deployments del sistema

```bash
./scripts/99-refresh-all.sh
```
> Este script hace los tres pasos en orden automáticamente

---

## 🔎 Verifica el estado

```bash
./scripts/09-check-status.sh
```

Y si hay pods fallando:
```bash
./scripts/18-status-check.sh
```

Para ver:
- Logs
- Describe pod
- Eliminar pod
- Rollout de un deployment individual

---

## 🧼 Limpieza total y reinstalación desde cero

```bash
./scripts/00-clean-environment.sh
```
> Conserva solo `/scripts/`. Elimina el resto para reinstalar completamente

---

## 🔁 Casos particulares

### Imagen no encontrada en pod
```
Error: ErrImagePull
Reason: failed to resolve reference "nombre:latest"
```
✅ Solución:
- Asegúrate de ejecutar `./07-import-images.sh` tras build

### El deployment no avanza
```
Waiting for deployment ... rollout to finish: 1 old replicas are pending termination
```
✅ Solución:
- Ejecuta `kubectl delete pod -l app=nombre -n central-platform`
- O `kubectl rollout restart deployment nombre -n central-platform`

---

Este procedimiento te permitirá recuperar cualquier error sin perder estructura ni limpieza del entorno.

