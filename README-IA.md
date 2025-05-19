# 🤖 README - Integración de Inteligencia Artificial (IA)

Este documento describe cómo está estructurada y desplegada la capa de servicios de IA en la Plataforma Centralizada.

---

## 🧠 Arquitectura actual de IA

La integración IA está pensada en dos fases:

### Fase 1 - IA externa vía OpenAI
- Un microservicio FastAPI (`openai-proxy`) actúa como intermediario seguro entre FYR y ChatGPT (vía API OpenAI)
- Permite definir la clave OpenAI desde `.env` o variables de entorno
- El frontend FYR solo interactúa con el endpoint `/ask` local

### Fase 2 - IA local (on-premise)
- Estructura preparada para desplegar `deepseek-onprem`, un servidor de modelo en contenedor
- Puede integrar modelos como Mistral, DeepSeek, LLaMA o similares vía Ollama, LM Studio, Text Generation WebUI
- Interfaz expuesta por API HTTP local

---

## 📂 Estructura en carpetas

```
scripts/backend-files/ia/
├── openai-proxy/
│   ├── main.py
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── .env.example
│   └── gateway-openai.yaml
└── deepseek-onprem/   ← (pendiente de desarrollo)
```

---

## 🚀 Despliegue del proxy OpenAI

1. Configura tu `.env`:
```dotenv
OPENAI_API_KEY=sk-xxxxx
OPENAI_MODEL=gpt-3.5-turbo
```

2. Construye e importa:
```bash
./scripts/15-deploy-openai-proxy.sh
```

3. Endpoint disponible:
```
POST http://openai-proxy-service:8010/ask
{ "prompt": "¿Cuál es el vino ideal para maridar con queso azul?" }
```

---

## 🌐 Conexión desde FYR

FYR debe apuntar a:
```env
VITE_AI_ENDPOINT=http://openai-proxy-service:8010/ask
```

---

## 🛠️ Pendiente en IA local

- Construcción del contenedor `deepseek-onprem`
- Integración de modelo HuggingFace/Transformers
- Despliegue vía GPU si está disponible
- Conexión con FYR ajustando VITE_AI_ENDPOINT a `http://deepseek-onprem:port/ask`

---

Este sistema garantiza flexibilidad: primero con OpenAI, luego con tu propia IA privada.

