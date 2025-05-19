# main.py
from fastapi import FastAPI, HTTPException
from goodwe_client import GoodWeClient
import os
import logging

logging.basicConfig(level=logging.INFO)

app = FastAPI()
client = GoodWeClient()

@app.get("/status")
def status():
    return {"status": "GoodWe Gateway running"}

@app.get("/plant-data")
def plant_data():
    try:
        data = client.get_plant_data()
        return data
    except Exception as e:
        logging.error(f"❌ Error obteniendo datos de planta: {e}")
        raise HTTPException(status_code=500, detail="Error obteniendo datos de planta")
