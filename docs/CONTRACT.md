# Kontrak Antar-Path — StationeryIQ

> Dokumen kesepakatan **FSD ↔ DS ↔ GenAI**. Status: **draft** — menunggu jawaban DS & GenAI.
> Sumber kebenaran teknis = kode di `backend/`. Bila kontrak berubah, perbarui file ini + beri tahu PIC.
>
> **Base API (live):** https://stationeryiq-production.up.railway.app
> **Frontend:** https://rilah.ujangkedu.my.id · **DB:** Supabase (PostgreSQL)

## Cara mengisi

- **DS:** jawab 5 poin di §A (kolom "Jawaban"). Bila tak ada perubahan, tulis **"skema products final"** + daftar kategori + atribut kartu.
- **GenAI:** jawab 7 poin di §B (kolom "Jawaban"). Bila setuju usulan FSD, tulis **"approve kontrak"** + kirim URL/interface + contoh JSON.
- Setelah diisi, commit file ini ke `main` (`docs/CONTRACT.md`).

---

## A. Untuk DS — 5 keputusan

**Cara FSD memakai DB saat ini:** `select *` dari tabel `products` (nama tabel bisa diubah via env `PRODUCTS_TABLE`). Tidak ada mapping kolom di kode — **perubahan skema otomatis ikut** selama nama tabel/kolom dipakai apa adanya.

| # | Pertanyaan | Asumsi / kondisi FSD sekarang | Jawaban DS |
|---|---|---|---|
| 1 | Kolom `products`: sekarang `id, nama, kategori, stok, harga`. Sudah final, atau perlu tambah (`satuan`, `ukuran`, `warna`)? | Dipakai apa adanya (`select *`); UI merender field yang ada | _(isi)_ |
| 2 | Ukuran/warna seragam: jadi kolom di `products`, atau tabel terpisah? Kalau terpisah, kirim skemanya + beri akses baca (`select`) ke `service_role` | Belum ada; FSD hanya baca `products` | _(isi)_ |
| 3 | Nama kategori: sekarang `Alat Tulis`, `Buku & Kertas`, `Seragam Sekolah`. Final? | `/kategori` = distinct dari kolom `kategori` | _(isi)_ |
| 4 | Info wajib di kartu produk: apa saja yang harus tampil? | UI chat menampilkan teks; daftar atribut belum ditetapkan | _(isi)_ |
| 5 | Akurasi stok: definisinya apa, dan data acuannya dari mana? | UI harus tampil = DB (zero false-positive), tidak membulatkan/mengarang | _(isi)_ |

### Catatan teknis untuk DS

- **Filter `/stok?q=`**: pencocokan **substring case-insensitive pada kolom `nama`**, dilakukan di sisi API setelah fetch (belum SQL). Bila butuh pencarian di kolom lain (kategori, alias "pulpen/bolpoin/pena"), beri tahu FSD.
- **Mock vs asli**: bila env Supabase kosong, API memakai data mock berbentuk sama (`id, nama, kategori, stok, harga`). Katalog asli harus kompatibel dengan bentuk ini.
- **Grant**: backend memakai `SUPABASE_SECRET_KEY`. Tabel/kolom baru harus bisa dibaca role terkait (`select`).
- **Logging (M3)**: format log query untuk evaluasi akurasi belum ditetapkan — DS tentukan field yang dibutuhkan.

---

## B. Untuk GenAI — 7 keputusan (kontrak `/chat`)

**Status FSD:** `/chat` masih **stub** (menerima `message`, membalas teks contoh). Router async + deploy (Railway, Docker, port dinamis) sudah siap menampung implementasi nyata.

| # | Pertanyaan | Usulan / kondisi FSD | Jawaban GenAI |
|---|---|---|---|
| 1 | Cara FSD memanggil RAG: URL (kirim), modul Python, atau lain? | FSD bisa panggil HTTP async atau import modul; beri URL/interface | _(isi)_ |
| 2 | Request: cocok `{ "message": "...", "riwayat": [...] }`? (`riwayat` boleh kosong dulu) | Frontend kirim `message`; `riwayat` opsional | _(isi)_ |
| 3 | Response: cocok `{ "reply": "...", "sumber": [...], "streaming": false }`? Field lain? | UI render teks; siap diperluas markdown | _(isi)_ |
| 4 | Streaming atau tidak? Kalau streaming: SSE atau potongan teks? | Backend (Railway) bisa streaming; frontend statis (cPanel) | _(isi)_ |
| 5 | Batas waktu: target < 2.5 dtk. Apa yang keluar kalau gagal/timeout? | FSD sediakan loading state + timeout; butuh teks fallback | _(isi)_ |
| 6 | Teks penolakan untuk pertanyaan di luar ATK/seragam (UI menampilkannya apa adanya) | Butuh string baku dari guardrail | _(isi)_ |
| 7 | Contoh nyata request dan response (JSON) | Bisa diambil dari stub, lihat §C | _(isi)_ |

### Catatan teknis untuk GenAI

- **CORS** backend: origin `https://rilah.ujangkedu.my.id` diizinkan (env `ALLOWED_ORIGINS`).
- **Deploy**: Railway (Docker). Bila RAG jadi service terpisah, kirim URL + cara auth (header/token) — **jangan** taruh secret di frontend.
- **Riwayat**: sekarang stateless; beri tahu bila butuh `riwayat` dikirim tiap request vs disimpan di server.
- **Format isi jawaban**: sebutkan plain text / markdown + batas panjang.

---

## C. Endpoint saat ini (referensi nyata)

### `GET /health`
```json
{ "status": "ok", "db": "supabase" }
```
`db` = `supabase` (kredensial terpasang) atau `mock`.

### `GET /stok?q=<opsional>`
```bash
curl "https://stationeryiq-production.up.railway.app/stok?q=bolpoin"
```
```json
{ "items": [ { "id": 1, "nama": "Bolpoin Hitam", "kategori": "Alat Tulis", "stok": 24, "harga": 3500 } ] }
```
- Tanpa `q` → semua baris.
- `q` → filter substring `nama` (case-insensitive).

### `GET /kategori`
```json
{ "items": ["Alat Tulis", "Buku & Kertas", "Seragam Sekolah"] }
```

### `POST /chat` — **STUB**
```bash
curl -X POST https://stationeryiq-production.up.railway.app/chat \
  -H "Content-Type: application/json" \
  -d "{\"message\":\"stok bolpoin hitam?\"}"
```
```json
{ "reply": "[stub RAG] Jawaban untuk: stok bolpoin hitam?" }
```

**Kontrak usulan (final setelah GenAI setuju):**
```json
// Request
{ "message": "stok bolpoin hitam?", "riwayat": [] }

// Response
{ "reply": "Bolpoin hitam tersedia 24 pcs, Rp3.500.", "sumber": ["products#1"], "streaming": false }
```

---

## D. Kode status & error

| Kondisi | Kode | Bentuk |
|---|---|---|
| Sukses | `200` | JSON sesuai endpoint |
| Body bukan JSON valid | `422` | `{ "detail": [...] }` (bawaan FastAPI) |
| Gagal baca DB | `503` | `{ "detail": "Gagal membaca <data>. Coba lagi." }` |
| RAG gagal/timeout | **TBD** | usul: `502`/`504` + `{ "reply": "<pesan ramah>" }` |

> Pesan error & UI dalam Bahasa Indonesia yang ramah.

---

## E. Checklist status

| Poin | PIC | Status |
|---|---|---|
| 5 keputusan katalog (§A) | DS | ⏳ menunggu |
| 7 keputusan kontrak `/chat` (§B) | GenAI | ⏳ menunggu |
| Skema/tabel varian + grant `service_role` (§A.2) | DS | ⏳ menunggu |
| URL/interface + contoh JSON RAG (§B.1, §B.7) | GenAI | ⏳ menunggu |
| Implementasi `/chat` nyata | FSD | ⏳ setelah §B final |
| Kartu produk sesuai atribut DS | FSD | ⏳ setelah §A.4 final |
| Filter/pencarian sesuai kebutuhan DS | FSD | ⏳ setelah §A catatan filter |