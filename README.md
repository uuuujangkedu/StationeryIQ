# StationeryIQ — Retail Copilot Chatbot (Toko Anugerah)

Chatbot untuk toko ATK dan seragam sekolah **Toko Anugerah**. Menjawab pertanyaan **stok, harga, dan ukuran/varian seragam** dalam bahasa sehari-hari, dirancang untuk pengguna non-teknis (pemilik toko, kasir, staf).

- **Durasi MVP:** 20 Nov – 20 Des 2026 (4 minggu)
- **Milestone akhir:** Live demo & UAT dengan pemilik toko, 20 Des 2026
- **Tim:** 6 orang, 3 path (Data Scientist, GenAI Engineer, Full Stack Developer)

## Arsitektur

```
Web Client (frontend)
      ⇅
API Backend (FastAPI)
      ⇅
RAG Engine (modul GenAI)
      ⇅
Database inventaris (PostgreSQL / SQLite)
```

## Tech Stack

| Bagian | Teknologi |
|---|---|
| Backend | FastAPI (Python), router async |
| Database | PostgreSQL / SQLite (skema dirancang path DS) |
| Frontend | Web app dengan chat UI (framework TBD) |
| Desain | FigCraft/Figma, font **Montserrat** & **Roboto** |
| Kolaborasi | GitHub (branch protection `main`), Kanban board, CI/CD dasar |

## Status — Minggu 1 (20–27 Nov)

Target **M1**: skeleton backend/frontend berjalan, repo + CI/CD dasar, wireframe disepakati.

| ID | PIC | Status | Tugas |
|---|---|---|---|
| TSK-FS-01 | Rafi | Berjalan | Setup repo GitHub, branching, environment, board tugas |
| TSK-FS-02 | Rizki | Berjalan | Wireframe UI chat + skeleton FastAPI & frontend |

### Desain — disetujui tim ✅

Wireframe chat UI (non-teknis, warna utama **biru muda**):

![Wireframe Chat — Desktop](docs/design/wireframe-chat-desktop.png)

- Warna utama: `#38BDF8` (biru muda)
- Font: Montserrat (heading), Roboto (body)
- Teks antarmuka: Bahasa Indonesia yang ramah

## Struktur Repo

```
.
├── backend/                        # FastAPI (skeleton)
│   ├── main.py                     # endpoint: health, stok, kategori, chat
│   ├── db.py                       # akses Supabase (fallback mock)
│   ├── test_api.py                 # cek cepat (pytest)
│   ├── .env.example                # template env (salin -> .env)
│   ├── Procfile / runtime.txt      # start command & versi Python (PaaS)
│   ├── pyproject.toml              # config ruff
│   └── requirements.txt
├── frontend/                       # chat UI (skeleton, tanpa build step)
│   ├── index.html
│   ├── styles.css
│   ├── config.js                   # URL backend API (atur saat produksi)
│   └── app.js
├── .github/workflows/ci.yml        # CI: lint + test
├── Procfile / requirements.txt / runtime.txt  # shim builder root (Railway/Railpack)
├── render.yaml                     # blueprint deploy backend (contoh)
├── docs/
│   ├── README.md                   # Ketergantungan antar peran
│   ├── BOARD.md                    # Kanban interim
│   ├── DEPLOY.md                   # Langkah deploy (PaaS + Vercel/cPanel)
│   └── design/                     # Aset desain (wireframe, mock)
├── README.md
├── ROLE_FULLSTACK_DEVELOPER.md     # Konteks role & task FSD
└── Roadmap & Task Breakdown ...xlsx  # Roadmap & task tracker
```

## Menjalankan (dev)

Backend:
```bash
cd backend
python -m venv .venv && .venv/Scripts/activate   # Windows; pakai bin/activate di Linux/macOS
pip install -r requirements.txt
cp .env.example .env                             # lalu isi SUPABASE_URL & SUPABASE_SECRET_KEY
uvicorn main:app --reload                        # http://127.0.0.1:8000
pytest                                           # cek cepat
```

> Env Supabase **opsional**: bila kosong, API jatuh ke data mock (dipakai CI & dev
> tanpa kredensial). `GET /health` melaporkan mode aktif (`supabase` / `mock`).
> Kredensial hanya hidup di server; jangan pernah dikirim ke frontend/browser.
> Schema tabel bisa berubah — baris dikirim apa adanya; nama tabel dapat diatur
> lewat env `PRODUCTS_TABLE` (default `products`).

Frontend (skeleton statis): buka `frontend/index.html` di browser, atau jalankan server statis:
```bash
cd frontend
python -m http.server 5500
```
`app.js` memanggil API sesuai `frontend/config.js` (`window.STATIONERYIQ_API`, default `http://127.0.0.1:8000`).

## Deploy

Lihat [`docs/DEPLOY.md`](docs/DEPLOY.md): backend ke PaaS (contoh Render), frontend statis ke Vercel atau cPanel, database di Supabase.

## Endpoint Minimum (rencana)

- `GET /health` — health check
- `GET /stok` — daftar stok produk
- `GET /kategori` — daftar kategori
- `POST /chat` — kirim pertanyaan, terima jawaban RAG

## Alur Kerja Git

- **Commit langsung ke `main`** diperbolehkan (branch protection tidak aktif).
- Sebelum commit: `git pull --ff-only` lalu `git push origin main`.
- CI (lint + test) berjalan otomatis pada push ke `main`; jangan push bila CI merah.
- Commit message ringkas: `tipe(lingkup): ringkasan` (mis. `feat(fs-04): ...`).
- Branch + PR opsional untuk perubahan besar/berisiko atau saat butuh review.

## Aturan Kontribusi

- Prioritaskan task berstatus **Tinggi** dan yang dekat checkpoint milestone.
- Kontrak antar-path (format JSON katalog, payload RAG) disepakati dengan PIC Data Science & GenAI sebelum diubah — lihat [`docs/README.md`](docs/README.md).
