import socket
from parser import t301

HOST = '0.0.0.0'
PORT = 9988

def start_server():
    print(f"🌐 Escuchando en TCP {HOST}:{PORT}")
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        while True:
            conn, addr = s.accept()
            with conn:
                print(f"📡 Conexión desde {addr}")
                data = conn.recv(1024)
                if not data:
                    continue
                hex_data = data.hex()
                result = t301.parse(hex_data)
                print("📍 Datos recibidos:", result)

if __name__ == "__main__":
    start_server()

