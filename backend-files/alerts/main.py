# main.py
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
import redis
import os
import logging
import json

app = FastAPI()
logging.basicConfig(level=logging.INFO)

REDIS_HOST = os.getenv("REDIS_HOST", "redis-service")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
REDIS_CHANNEL = os.getenv("REDIS_CHANNEL", "platform-events")

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

class Alert(BaseModel):
    type: str
    source: str
    message: str
    timestamp: str

@app.get("/alerts/health")
def health():
    return {"status": "alerts ok"}

@app.post("/alerts")
def push_alert(alert: Alert):
    alert_data = alert.dict()
    try:
        r.publish(REDIS_CHANNEL, json.dumps(alert_data))
        logging.info(f"🔔 Alert publicada: {alert_data}")
        return {"published": True, "data": alert_data}
    except Exception as e:
        logging.error(f"Error publicando alerta: {str(e)}")
        raise HTTPException(status_code=500, detail="Error al publicar alerta")

@app.get("/alerts/test")
def test_alert():
    payload = {"type": "test", "source": "alerts-service", "message": "Test alerta", "timestamp": "now"}
    r.publish(REDIS_CHANNEL, json.dumps(payload))
    logging.info("🧪 Alerta de test enviada")
    return {"status": "test sent"}
