# main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests
import os
import logging
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()
logging.basicConfig(level=logging.INFO)

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")

class ChatInput(BaseModel):
    prompt: str

@app.get("/health")
def health():
    return {"status": "openai-proxy ok"}

@app.post("/ask")
def ask_chatgpt(data: ChatInput):
    if not OPENAI_API_KEY:
        raise HTTPException(status_code=500, detail="API key no configurada")

    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "Content-Type": "application/json"
    }

    body = {
        "model": OPENAI_MODEL,
        "messages": [{"role": "user", "content": data.prompt}],
        "temperature": 0.7
    }

    try:
        response = requests.post("https://api.openai.com/v1/chat/completions", json=body, headers=headers, timeout=10)
        response.raise_for_status()
        return response.json()["choices"][0]["message"]
    except requests.RequestException as e:
        logging.error(f"Error consultando OpenAI: {str(e)}")
        raise HTTPException(status_code=502, detail="Error consultando OpenAI")
