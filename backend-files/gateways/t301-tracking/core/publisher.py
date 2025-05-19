# core/publisher.py
import redis.asyncio as aioredis
import os
import json
import logging

REDIS_HOST = os.getenv("REDIS_HOST", "redis-service")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
REDIS_CHANNEL = os.getenv("REDIS_CHANNEL", "platform-events")

async def publish_to_redis(data: dict):
    try:
        redis = aioredis.Redis(host=REDIS_HOST, port=REDIS_PORT)
        await redis.publish(REDIS_CHANNEL, json.dumps(data))
        await redis.close()
    except Exception as e:
        logging.error(f"❌ Error publicando a Redis: {str(e)}")

