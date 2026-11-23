FROM python:3.13-slim

WORKDIR /app

# Dependensi server (sumber tunggal: backend/requirements.txt)
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Kode aplikasi
COPY backend/ ./

ENV PORT=8080
EXPOSE 8080
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8080}"]
