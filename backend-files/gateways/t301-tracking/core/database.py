# core/database.py
import asyncpg
import os
import logging

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "postgresql-service")
POSTGRES_DB = os.getenv("POSTGRES_DB", "centraldb")
POSTGRES_USER = os.getenv("POSTGRES_USER", "admin")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "secret")

async def store_record(data: dict, raw_hex: str):
    try:
        conn = await asyncpg.connect(
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD,
            database=POSTGRES_DB,
            host=POSTGRES_HOST
        )

        await conn.execute('''
            INSERT INTO t301_events (type, latitude, longitude, imei, alarm_code, raw)
            VALUES ($1, $2, $3, $4, $5, $6)
        ''',
            data.get("type"),
            data.get("latitude"),
            data.get("longitude"),
            data.get("imei"),
            data.get("alarm_code"),
            raw_hex
        )
        await conn.close()
    except Exception as e:
        logging.error(f"❌ Error guardando en la base de datos: {str(e)}")
