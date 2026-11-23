# Deploy — StationeryIQ

Tiga bagian: **backend** (PaaS), **frontend** (statis: Vercel atau cPanel), **database** (Supabase, sudah hosted).

> Aturan: kredensial hanya di sisi server. Jangan pernah commit `.env` atau menaruh
> `SUPABASE_SECRET_KEY` di frontend/browser.

## 1. Backend (PaaS — contoh Render)

Opsi A — pakai blueprint:
1. Render → **New** → **Blueprint** → pilih repo ini. `render.yaml` akan terbaca.
2. Isi env vars saat diminta (lihat daftar di bawah).

Opsi B — manual:
1. Render → **New** → **Web Service** → connect repo.
2. **Root Directory:** `backend`
3. **Build Command:** `pip install -r requirements.txt`
4. **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`
5. Tambah env vars.

Env vars wajib:

| Key | Nilai | Rahasia? |
|---|---|---|
| `SUPABASE_URL` | Project URL Supabase | tidak |
| `SUPABASE_SECRET_KEY` | secret key Supabase | **ya** |
| `ALLOWED_ORIGINS` | origin frontend, mis. `https://stationeryiq.vercel.app` | tidak |

Catatan:
- `backend/Procfile` sudah disediakan (dipakai Railway/Heroku-style dan Render).
- Versi Python: **tidak dipin** — builder memakai default-nya. Bila perlu pin, set env builder `MISE_PYTHON_GITHUB_ATTESTATIONS=false` (Railway/mise) atau `PYTHON_VERSION` (Render). `runtime.txt` lama dihapus karena pin `python-3.13.0` gagal verifikasi attestation mise.
- Host lain: Railway/Fly.io ikut pola sama (root `backend`, start `uvicorn main:app --host 0.0.0.0 --port $PORT`).
- Verifikasi: `GET https://<host>/health` → `{"status":"ok","db":"supabase"}`.

### Railway (Railpack)

**Wajib: set Root Directory = `backend`** di Service Settings. Tanpa itu, builder mencari app di root repo dan gagal.

Setelan service:
- **Root Directory:** `backend`
- **Build Command:** `pip install -r requirements.txt`
- **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`
- **Env:** `SUPABASE_URL`, `SUPABASE_SECRET_KEY`, `ALLOWED_ORIGINS`

Bila muncul `Could not open requirements file: '/app/backend/requirements.txt'` (path dobel),
periksa: Root Directory diisi **dan** tidak ada shim `requirements.txt`/`Procfile` di root repo.
Kosongkan Build/Start Command agar memakai setelan di atas, lalu redeploy.

## 2. Frontend (statis)

Frontend murni statis (tanpa build). Dua pilihan:

### Vercel
1. Vercel → **Add New** → **Project** → import repo.
2. **Root Directory:** `frontend`
3. **Framework Preset:** `Other` · **Build Command:** kosong · **Output Directory:** `.`
4. Deploy.
5. Edit `frontend/config.js` → `window.STATIONERYIQ_API = "https://<host-backend>"`, commit.

### cPanel
1. Upload isi `frontend/` ke `public_html`.
2. Edit `config.js` → set `window.STATIONERYIQ_API` ke URL backend.
3. (Opsional) `.htaccess` untuk cache statis.

## 3. Setelah frontend live

- Set `ALLOWED_ORIGINS` di backend ke origin frontend persis (mis. `https://stationeryiq.vercel.app`), lalu redeploy/restart backend.
- Buka situs → cek badge status "terhubung" dan uji chat.

## Tips

- Ubah `SUPABASE_URL`/key → restart backend.
- Schema produk berubah → tidak perlu ubah kode selama endpoint baca `products` (atau set `PRODUCTS_TABLE`).
- Jangan aktifkan streaming bila backend di host yang buffer respons (mis. Passenger/cPanel).
