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
- Host lain: Fly.io/Heroku-style ikut pola sama (`uvicorn main:app --host 0.0.0.0 --port $PORT`).
- Verifikasi: `GET https://<host>/health` → `{"status":"ok","db":"supabase"}`.

### Railway (aktif — pakai Dockerfile)

Repo punya `Dockerfile` di root + `railway.json` (`builder: DOCKERFILE`). Builder default (Railpack) **tidak** dipakai
karena hanya meng-copy file `requirements.txt` ke root, sehingga include ke `backend/` gagal.

Setelan service (tanpa perlu Root Directory):
- **Root Directory:** kosong (Dockerfile di root)
- **Env:** `SUPABASE_URL`, `SUPABASE_SECRET_KEY` (rahasia), `ALLOWED_ORIGINS`
- Domain: `railway domain` → `https://<service>-production.up.railway.app`

Terverifikasi live: `/health` `{"status":"ok","db":"supabase"}`, `/kategori`, `/stok`, `/chat` semua `200`.
Catatan: `railway.json` (config-as-code) deprecated per 2026-12-01; migrasi ke `.railway/railway.ts` bila melewati tanggal itu.

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

- Frontend produksi saat ini: **https://rilah.ujangkedu.my.id** (statis; upload isi `frontend/`).
- `ALLOWED_ORIGINS` di backend sudah di-set ke origin itu.
- Buka situs → cek badge status "terhubung" dan uji chat.
- Ubah URL backend → edit `frontend/config.js` (`window.STATIONERYIQ_API`) lalu upload ulang.

## Tips

- Ubah `SUPABASE_URL`/key → restart backend.
- Schema produk berubah → tidak perlu ubah kode selama endpoint baca `products` (atau set `PRODUCTS_TABLE`).
- Jangan aktifkan streaming bila backend di host yang buffer respons (mis. Passenger/cPanel).
