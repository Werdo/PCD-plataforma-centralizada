**Database Structure Document for Centralized Platform - Bodega Emilio Moro**

---

**1. Document Objective**

This document outlines the initial database structure for a centralized information platform at Bodega Emilio Moro. The platform must be capable of storing and managing current, past, and future information across all areas of the winery: vineyard, production, energy, sensors, automation, traceability, etc. The structure is designed to be scalable, parameterizable, and prepared for future analysis and integration with AI and BI systems.

---

**2. Design Principles**

* Modularity and normalization.
* Separation between physical, logical, temporal, and historical data.
* Dynamic parameterization.
* Ready for advanced analytics and visualization.
* Dual-technology approach: PostgreSQL for structured data and MongoDB for unstructured data, logs, and massive event tracking.

---

**3. General Structure**

### 3.1 Physical Entities (Infrastructure and Devices)

**Locations** *(PostgreSQL)*

* id (PK UUID)
* name
* type (winery, room, vineyard, cellar, bottle rack, etc.)
* coordinates (geom)
* parent\_location\_id (FK)

**Rooms** *(PostgreSQL)*

* id (PK UUID)
* name
* type (barrel, sleeper, bottle)
* location\_id (FK)

**BarrelLocation** *(PostgreSQL)*

* id (PK UUID)
* barrel\_id (FK)
* room\_id (FK)
* position
* start\_date
* end\_date (nullable)

**BottleRacks** *(PostgreSQL)*

* id (PK UUID)
* name
* room\_id (FK)
* capacity

**Cellars** *(PostgreSQL)*

* id (PK UUID)
* name
* location\_id (FK)
* type (crianza, reserva, etc.)

**Devices** *(PostgreSQL)*

* id (PK UUID)
* type (sensor, actuator, vehicle, etc.)
* brand
* model
* location\_id (FK)
* active (bool)

**Sensors** *(PostgreSQL)*

* id (PK UUID)
* device\_id (FK)
* sensor\_type
* unit\_measurement
* operating\_range

---

### 3.2 Vineyard Data (Plots, Grids, Soil and Climate Sensors)

**Plots** *(PostgreSQL)*

* id (PK UUID)
* name
* location\_id (FK)
* area
* ownership\_type (owned, leased)
* active (bool)

**Grids** *(PostgreSQL)*

* id (PK UUID)
* plot\_id (FK)
* local\_name
* coordinates (geom)
* usage

**FieldSensors** *(PostgreSQL)*

* id (PK UUID)
* grid\_id (FK)
* sensor\_type
* device\_id (FK)
* installation\_date

---

### 3.3 Readings, States, and Events

**Readings** *(MongoDB)*

* sensor\_id
* timestamp
* value
* unit
* metadata (optional JSON)

**States** *(PostgreSQL)*

* id (PK UUID)
* object\_id
* object\_class
* state
* start\_timestamp
* end\_timestamp

**Events** *(MongoDB)*

* affected\_object\_id
* object\_class
* event\_type
* timestamp
* metadata (JSON)

---

### 3.4 Production, Barrels, and Traceability

**Barrels** *(PostgreSQL)*

* id (PK UUID)
* wood\_type
* volume
* location\_id (FK)

**ProductionProcesses** *(PostgreSQL)*

* id (PK UUID)
* process\_type
* object\_id (FK)
* start\_date
* end\_date
* result (JSONB)

**Traceability** *(PostgreSQL)*

* id (PK UUID)
* object\_id
* object\_class
* previous\_location\_id
* new\_location\_id
* movement\_date

**FermentationValues** *(PostgreSQL)*

* id (PK UUID)
* process\_id (FK)
* value\_type
* value
* timestamp

---

### 3.5 Catalogs and Parameterization

**TypeCatalog** *(PostgreSQL)*

* id (PK)
* group
* name
* description

**Units** *(PostgreSQL)*

* id (PK)
* symbol
* name
* type

**Configurations** *(PostgreSQL)*

* key (PK)
* value
* value\_type

**WineTypes** *(PostgreSQL)*

* id
* name
* description

**Vintages** *(PostgreSQL)*

* id
* year
* climate\_condition
* notes

**GrapeTypes** *(PostgreSQL)*

* id
* name
* characteristics

**GrapeOrganolepticValues** *(PostgreSQL)*

* id
* grape\_type\_id (FK)
* value\_type
* value

**WineOrganolepticValues** *(PostgreSQL)*

* id
* wine\_type\_id (FK)
* value\_type
* value

---

### 3.6 Users and Security

**Users** *(PostgreSQL)*

* id
* name
* email
* active (bool)
* creation\_date

**Roles** *(PostgreSQL)*

* id
* name
* permissions (JSONB)

**Groups** *(PostgreSQL)*

* id
* name
* description

**UserRoleGroup** *(PostgreSQL)*

* id
* user\_id (FK)
* role\_id (FK)
* group\_id (FK)

**SystemViews** *(PostgreSQL)*

* id
* name
* description
* resource\_url

**Areas** *(PostgreSQL)*

* id
* name
* description

---

**4. Future Considerations**

* Use of PostgreSQL with extensions such as PostGIS for geospatial data and JSONB for flexibility.
* MongoDB dedicated to logs, massive events, and high-frequency sensor readings.
* Version control and auditing of critical changes.
* Backup automation and archiving policies.

---

**5. Conclusion**

This structure combines the best of both worlds: the robustness and consistency of relational data in PostgreSQL, and the flexibility of MongoDB for large-scale unstructured data. It allows for efficient, traceable, and scalable management of all winery information, ready for advanced analytics and digital transformation.
base de datos sólida, escalable y preparada para el análisis de datos en la plataforma de centralización de Bodegas Emilio Moro, la clave es estructurarla en torno a una arquitectura flexible y normalizada, con una separación clara entre:

Datos físicos (dispositivos, ubicaciones, sensores)

Datos lógicos (tipologías, estados, procesos)

Datos temporales e históricos (lecturas, eventos, trazabilidad)

Parametrización dinámica (catálogos, unidades, configuraciones)

Estructura base recomendada (modelo relacional con extensibilidad para NoSQL)
1. Entidades físicas (objetos medibles o controlables)
plaintext
Copiar
Editar
- Ubicaciones
  - id
  - nombre
  - tipo (bodega, campo, sala, etc.)
  - coordenadas
  - jerarquía (relación con otra ubicación)

- Dispositivos
  - id
  - tipo (sensor, actuador, vehículo, etc.)
  - marca/modelo
  - ubicación_id (FK)
  - activo (bool)

- Sensores
  - id
  - dispositivo_id (FK)
  - tipo_sensor (temperatura, humedad, presión, etc.)
  - unidad_medida
  - rango_operativo
2. Lecturas y trazabilidad
plaintext
Copiar
Editar
- Lecturas
  - id
  - sensor_id (FK)
  - timestamp
  - valor
  - unidad (FK opcional si hay conversión)

- Eventos
  - id
  - tipo_evento (FK a catálogo)
  - objeto_afectado_id
  - clase_objeto ('barrica', 'depósito', etc.)
  - timestamp
  - metadatos (jsonb, para datos flexibles)

- Estados
  - id
  - objeto_id
  - clase_objeto
  - estado
  - timestamp_inicio
  - timestamp_fin (nullable)
3. Catálogos y parametrización
plaintext
Copiar
Editar
- CatálogoTipos
  - id
  - grupo (sensor, estado, evento, etc.)
  - nombre
  - descripción

- Unidades
  - id
  - símbolo
  - nombre
  - tipo (temperatura, volumen, energía)

- Configuraciones
  - clave
  - valor
  - tipo_valor (string, int, bool, json)
4. Historiales y procesos productivos
plaintext
Copiar
Editar
- Barricas
  - id
  - tipo_madera
  - volumen
  - ubicación_id

- Producción
  - id
  - tipo_proceso (fermentación, trasiego, etc.)
  - objeto_id (barrica, depósito, etc.)
  - fecha_inicio
  - fecha_fin
  - resultado (jsonb o FK a resultado)

- Trazabilidad
  - id
  - objeto_id
  - clase_objeto
  - ubicación_anterior_id
  - ubicación_nueva_id
  - fecha_movimiento
5. Extensiones posibles (NoSQL o JSONB en PostgreSQL)
Información sin esquema fijo (ej. configuraciones por sensor, logs de automatización)

Datos anidados que cambian con frecuencia o sin relaciones claras

Opciones: usar columnas tipo jsonb en PostgreSQL, o tener tablas separadas para logs en MongoDB/InfluxDB/TimescaleDB si hay millones de registros por sensor

Ventajas de esta estructura:
Parametrizable: puedes agregar nuevos tipos de sensores o ubicaciones sin alterar la estructura.

Escalable: separa datos de configuración, de lectura, de estado y de objetos físicos.

Trazable: permite reconstruir la historia de cualquier objeto o proceso.

Lista para analítica: fácilmente conectable a Power BI, Grafana o IA.

Extensión para gestión de parcelas en campo
plaintext
Copiar
Editar
- Parcelas
  - id
  - nombre
  - ubicación_id (FK, si se quiere anidar)
  - superficie (ha)
  - tipo_tenencia (propiedad, subarrendada)
  - activo (bool)

- Cuadrículas
  - id
  - parcela_id (FK)
  - nombre_local
  - coordenadas (polígono o bbox)
  - uso (viñedo, olivar, experimental, etc.)

- SensoresCampo
  - id
  - cuadrícula_id (FK)
  - tipo_sensor (humedad suelo, temperatura, etc.)
  - dispositivo_id (FK)
  - fecha_instalacion
Esta estructura te permite:

Asociar sensores a zonas específicas del campo.

Analizar datos por cuadrícula o por parcela.

Diferenciar parcelas en propiedad o subarrendadas.

Escalar fácilmente cuando se incorporen nuevas áreas o tecnologías de sensorización.

✅ Casos de uso típicos que puedes implementar
Agente de predicción de fermentación óptima

Agente de recomendación de cosecha basada en clima y parcela

Clasificador organoléptico de vino por lectura sensorial

Alertas inteligentes (superan umbrales dinámicos o basados en IA)

Copiloto interno que responda preguntas sobre datos históricos (RAG + IA)

✅ Infraestructura compatible
Tu sistema ya soporta:

Contenerización con Docker

Despliegue con Kubernetes + Helm

Soporte para modelos en REST API o WebSocket

Elastic + Kibana para trazabilidad

Redis para triggers y agentes reactivos

¿Quieres que te prepare un esquema técnico para un primer microservicio de IA (por ejemplo, un predictor de fermentación o un chatbot sobre tus datos)?






Tú dijiste:
quiero empezar por el backend
ChatGPT Plus
Perfecto. Para empezar a montar el backend con IA integrada sobre tu plataforma actual, seguiremos estos pasos estructurados y compatibles con tu stack:

✅ 1. Estructura base del backend (FastAPI + PostgreSQL + MongoDB)
Ya tienes esta parte definida en tu documentación. Se compondrá de:

/api/v1/: rutas principales

/ai/: nueva zona donde montaremos los servicios IA

Base de datos relacional: PostgreSQL

Base de datos no relacional (series): MongoDB

✅ 2. Nueva carpeta de IA: ai-agent-service dentro de backend/
Estructura mínima recomendada:

graphql
Copiar
Editar
backend/
├── ai-agent/
│   ├── app/
│   │   ├── ai/                   # Lógica de IA
│   │   │   ├── predictors.py     # Modelos predictivos
│   │   │   ├── loader.py         # Carga de modelos
│   │   │   └── utils.py
│   │   ├── api/
│   │   │   └── ai.py             # Rutas API para IA
│   │   ├── db/                   # Acceso a datos (si es necesario)
│   │   ├── core/                 # Configuración
│   │   ├── services/             # Reglas de negocio IA
│   │   └── main.py               # Punto de entrada FastAPI
├── Dockerfile
├── requirements.txt
✅ 3. Tecnologías recomendadas
FastAPI – API REST ligera y rápida.

Pydantic – Validación de entrada/salida.

Scikit-learn o XGBoost – Para predicción rápida en procesos de fermentación, rendimiento, etc.

Pandas/Numpy – Para tratamiento de datos.

Uvicorn – Para servir FastAPI.

Joblib o ONNX – Para cargar modelos entrenados.

✅ 4. Ejemplo básico de endpoint de predicción
python
Copiar
Editar
# app/api/ai.py
from fastapi import APIRouter
from app.ai.predictors import predict_fermentation

router = APIRouter()

@router.post("/predict-fermentation")
def predict(data: dict):
    prediction = predict_fermentation(data)
    return {"prediction": prediction}
python
Copiar
Editar
# app/ai/predictors.py
import joblib
import numpy as np

model = joblib.load("models/fermentation_predictor.joblib")

def predict_fermentation(data: dict):
    features = np.array([data["temperature"], data["ph"], data["density"]]).reshape(1, -1)
    return float(model.predict(features)[0])
✅ 5. Despliegue
Dockeriza este servicio como cualquier otro microservicio.

Lo puedes exponer como:

bash
Copiar
Editar
/api/v1/ai/predict-fermentation
Se conecta a PostgreSQL o MongoDB si necesita registros históricos.

✅ 6. Próximo paso
Puedo generarte:

El código inicial para este microservicio (ai-agent)

Un Dockerfile listo

Script de prueba con curl o Postman

Ejemplo de modelo entrenado ficticio si no tienes uno

¿Quieres que prepare ese primer servicio IA como plantilla inicial?






Tú dijiste:
primero necesito montar el backend Refine + Material UI
ChatGPT Plus
Perfecto. Para montar el backend administrativo usando Refine + Material UI, conectado a tu API REST en FastAPI y a PostgreSQL, te recomiendo seguir esta estructura:

✅ ¿Qué es Refine?
Refine es un framework React avanzado que te permite construir interfaces administrativas completas sin partir desde cero, ideal para consumir APIs REST, GraphQL o incluso directamente bases de datos.

✅ Stack propuesto para tu backend administrativo
Componente	Tecnología
UI Admin	Refine (React + Material UI)
API REST backend	FastAPI
Autenticación	OAuth2 (Microsoft 365 / Azure AD)
Base de datos	PostgreSQL / MongoDB
Despliegue	Docker + Kubernetes (ya planificado)

✅ Pasos para instalar Refine con Material UI
Crear el proyecto Refine:

bash
Copiar
Editar
npx create-refine-app admin-panel \
  --template refine-react \
  --ui-framework material-ui \
  --router react-router-dom \
  --auth-provider \
  --data-provider custom \
  --language typescript
Esto te genera un proyecto base en React + TypeScript + Material UI + Auth + estructura modular.

Estructura resultante:

bash
Copiar
Editar
admin-panel/
├── src/
│   ├── pages/
│   ├── components/
│   ├── providers/
│   ├── authProvider/
│   ├── dataProvider/
│   └── App.tsx
├── public/
├── package.json
├── tsconfig.json
└── Dockerfile
Conectar con tu API FastAPI:

En src/dataProvider/index.ts, usa @refinedev/simple-rest o crea uno personalizado.

ts
Copiar
Editar
import { DataProvider } from "@refinedev/simple-rest";

export const dataProvider = DataProvider("http://localhost:8000/api/v1");
Configurar autenticación SSO (OAuth2):

Refine permite usar Microsoft 365 con OAuth2. Puedes integrar tu authProvider en src/authProvider/index.ts.

Ejemplo de pseudocódigo para SSO:

ts
Copiar
Editar
export const authProvider = {
  login: async () => {
    window.location.href = "https://login.microsoftonline.com/...";
    return { success: true };
  },
  logout: async () => { /* ... */ },
  checkAuth: async () => { /* ... */ },
  getPermissions: async () => { /* ... */ },
};
Desarrollar recursos admin (CRUD):
En App.tsx puedes definir los recursos como:

tsx
Copiar
Editar
<Refine
  dataProvider={dataProvider}
  authProvider={authProvider}
  resources={[
    { name: "users", list: "/users", edit: "/users/edit/:id", create: "/users/create" },
    { name: "devices", list: "/devices", edit: "/devices/edit/:id" },
    { name: "plots", list: "/plots" },
  ]}
/>
Despliegue
Puedes construirlo con Docker y desplegarlo junto al resto de tus servicios:

dockerfile
Copiar
Editar
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "start"]
✅ ¿Te gustaría que te prepare...?
El proyecto inicial Refine con Material UI ya conectado a FastAPI

Un CRUD de ejemplo para /users y /devices

Dockerfile completo listo para producción

Solo dime y te lo entrego empaquetado para arrancar de inmediato.