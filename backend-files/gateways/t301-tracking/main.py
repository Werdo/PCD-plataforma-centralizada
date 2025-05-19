# main.py
import asyncio
import socket
import logging
from core.parser import parse_t301
from core.database import store_record
from core.publisher import publish_to_redis

HOST = "0.0.0.0"
PORT = 9988

logging.basicConfig(level=logging.INFO)

async def handle_connection(reader, writer):
    addr = writer.get_extra_info("peername")
    logging.info(f"🔌 Conexión entrante desde {addr}")

    try:
        data = await reader.read(1024)
        if not data:
            return

        hex_string = data.hex()
        logging.info(f"📦 Trama recibida: {hex_string}")

        parsed = parse_t301(hex_string)
        if parsed:
            await store_record(parsed, hex_string)
            await publish_to_redis(parsed)
            logging.info(f"✅ Datos almacenados y publicados: {parsed['type']}")
        else:
            logging.warning("❗ Trama no reconocida o inválida")

    except Exception as e:
        logging.error(f"❌ Error en conexión: {str(e)}")

    writer.close()
    await writer.wait_closed()

async def start_server():
    server = await asyncio.start_server(handle_connection, HOST, PORT)
    addr = server.sockets[0].getsockname()
    logging.info(f"🚀 Gateway T301 escuchando en {addr}")
    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(start_server())
