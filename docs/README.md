# Ketergantungan Antar Peran — StationeryIQ

> Dokumen untuk pekerjaan yang **tidak bisa diselesaikan satu path saja**.
> Sumber: *Roadmap & Task Breakdown per Path* + `ROLE_FULLSTACK_DEVELOPER.md` (§6).
> Status di sini snapshot; verifikasi ke board/task sebelum diandalkan.

## 1. Ringkas: siapa memblokir siapa

| Path penerima | Pekerjaan yang terblokir | Butuh dari | Yang harus disepakati | Workaround sementara |
|---|---|---|---|---|
| **FSD** | Endpoint `stok`/`kategori` final | DS | Format JSON katalog + skema kolom | Data mock (aktif) |
| **FSD** | Endpoint `/chat` (RAG) | GenAI | Spesifikasi interface RAG + payload streaming/non-streaming | Stub RAG (aktif) |
| **FSD** | Kartu informasi produk (atribut lengkap di UI) | DS | Daftar atribut produk yang wajib tampil | Data mock |
| **FSD** | Verifikasi akurasi stok di layar | DS | Definisi akurasi + sumber data | — |
| **FSD** | Deployment stabil (kuota/latensi RAG) | GenAI | Parameter model akhir + batas kuota token | — |
| **DS** | Evaluasi kelengkapan atribut di UI | FSD | Kontrak endpoint + bentuk respon | — |
| **GenAI** | Pipeline RAG berisi data nyata | DS | Katalog data terstandar | — |
| **GenAI** | Output RAG sesuai format pesan UI | FSD | Kontrak payload respons | — |

## 2. Kontrak M1 (wajib disepakati sebelum Minggu 2)

> **Detail lengkap + kolom jawaban DS & GenAI: [`CONTRACT.md`](CONTRACT.md).** Ringkas di bawah.

- **JSON katalog produk** (FSD × DS)
  - Bentuk saat ini (di pakai `backend/db.py`, `select *`): `{ id, nama, kategori, stok, harga }`
  - Status: **sebagian** — belum formal; perlu konfirmasi apakah kolom/varian berubah.
- **Interface RAG** (FSD × GenAI)
  - Input: `{ message: str, riwayat?: [...] }`
  - Output: `{ reply: str, sumber?: [...], streaming: bool }`
  - Status: **stub** di `/chat`; belum disepakati.
- **Filter kategori** (FSD × DS)
  - Sumber nama kategori: kolom `kategori` (distinct). Status: chip UI sudah ada, nama belum difinalkan DS.

## 3. Definisi "selesai" antar-path

- [ ] DS menyerahkan katalog data terstandar + skema final
- [ ] GenAI menyerahkan spesifikasi interface RAG + contoh payload
- [ ] FSD menyediakan kontrak endpoint (stok, kategori, chat) dalam bentuk dokumen/OpenAPI
- [ ] Ketiga path menyepakati payload respons (streaming/non-streaming)

## 4. Aturan koordinasi

- Perubahan format JSON atau payload yang dipakai path lain **wajib** diberitahukan ke PIC terkait sebelum di-commit.
- Wilayah kerja tidak diubah sepihak: skema DB = DS, pipeline/prompt RAG = GenAI, endpoint & UI = FSD.
- Bila ragu, tulis pertanyaannya di kolom kontrak di atas lalu konfirmasi ke PIC.
