# main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import psycopg2
import os
import logging

app = FastAPI()
logging.basicConfig(level=logging.INFO)

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "postgresql-service")
POSTGRES_DB = os.getenv("POSTGRES_DB", "centraldb")
POSTGRES_USER = os.getenv("POSTGRES_USER", "admin")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "secret")

class Device(BaseModel):
    name: str
    status: str

def db_connect():
    return psycopg2.connect(
        host=POSTGRES_HOST,
        database=POSTGRES_DB,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD
    )

@app.get("/api/v1/health")
def health():
    return {"status": "api-rest ok"}

@app.get("/api/v1/devices")
def get_devices():
    try:
        conn = db_connect()
        cur = conn.cursor()
        cur.execute("SELECT id, name, status FROM devices;")
        result = cur.fetchall()
        cur.close()
        conn.close()
        return [{"id": r[0], "name": r[1], "status": r[2]} for r in result]
    except Exception as e:
        logging.error(f"Database error: {str(e)}")
        raise HTTPException(status_code=500, detail="Database query failed")

@app.post("/api/v1/devices")
def create_device(device: Device):
    try:
        conn = db_connect()
        cur = conn.cursor()
        cur.execute("INSERT INTO devices (name, status) VALUES (%s, %s) RETURNING id;", (device.name, device.status))
        device_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        return {"id": device_id, "name": device.name, "status": device.status}
    except Exception as e:
        logging.error(f"Insert error: {str(e)}")
        raise HTTPException(status_code=500, detail="Insert failed")
