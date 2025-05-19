# core/parser.py
import logging

TRAMA_TYPES = {
    "01": "login",
    "12": "location",
    "13": "heartbeat",
    "16": "alarm"
}

def parse_t301(hex_string):
    try:
        if not hex_string.startswith("7878"):
            return None

        proto_id = hex_string[6:8]
        tipo = TRAMA_TYPES.get(proto_id, "unknown")

        result = {
            "type": tipo,
            "raw": hex_string
        }

        if tipo == "location":
            lat_hex = hex_string[14:22]
            lng_hex = hex_string[22:30]
            result["latitude"] = int(lat_hex, 16) / 1800000
            result["longitude"] = int(lng_hex, 16) / 1800000

        elif tipo == "login":
            imei = hex_string[8:22]
            result["imei"] = imei

        elif tipo == "alarm":
            result["alarm_code"] = hex_string[8:10]

        return result
    except Exception as e:
        logging.error(f"❌ Error parseando trama: {str(e)}")
        return None

