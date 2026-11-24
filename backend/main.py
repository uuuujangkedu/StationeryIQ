"""StationeryIQ API — skeleton FastAPI.

Endpoint minimum (roadmap): health, stok, kategori, chat.
Stok & kategori dibaca dari Supabase (fallback mock bila env kosong).
Respons /chat masih stub; kontraknya disepakati dengan path GenAI.
"""

import logging
import os

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

import db

# Pesan asli DB dicatat di server; klien tetap dapat pesan ramah (tanpa detail).
logger = logging.getLogger("stationeryiq.api")

app = FastAPI(title="StationeryIQ API", version="0.0.1")

# Origin diatur via env ALLOWED_ORIGINS (dipisah koma); default "*" untuk dev.
_origins = [o.strip() for o in os.getenv("ALLOWED_ORIGINS", "*").split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_origins or ["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok", "db": db.mode()}


@app.get("/stok")
def list_stok(q: str | None = None):
    try:
        return {"items": db.fetch_stok(q)}
    except Exception as exc:
        logger.warning("stok gagal: %s", exc)
        raise HTTPException(status_code=503, detail="Gagal membaca data stok. Coba lagi.") from exc


@app.get("/kategori")
def list_kategori():
    try:
        return {"items": db.fetch_kategori()}
    except Exception as exc:
        logger.warning("kategori gagal: %s", exc)
        raise HTTPException(status_code=503, detail="Gagal membaca kategori. Coba lagi.") from exc


@app.post("/chat")
def chat(payload: dict):
    """Stub RAG. Kontrak payload respons disepakati dengan path GenAI."""
    pesan = (payload or {}).get("message", "")
    return {"reply": f"[stub RAG] Jawaban untuk: {pesan}"}
