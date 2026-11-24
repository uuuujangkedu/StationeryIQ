# ERD — StationeryIQ (Toko Anugerah)

Sumber kebenaran: [`db/schema.sql`](../db/schema.sql). Diagram di bawah ikut berubah
saat skema berubah — perbarui file ini di PR yang sama.

`log_chat` tidak punya relasi FK (`sesi_id` teks bebas). View `products`
(lihat `schema.sql`) menyajikan `{id, nama, kategori, stok, harga, satuan}`
sebagai bentuk baca yang dipakai backend.

```mermaid
erDiagram
    kategori ||--o{ produk : "kategori_id"
    produk ||--o{ varian_produk : "produk_id"
    produk ||--o{ item_pesanan : "produk_id"
    varian_produk |o--o{ item_pesanan : "varian_id"
    pengguna |o--o{ pesanan : "pengguna_id"
    pesanan ||--o{ item_pesanan : "pesanan_id"

    kategori {
        bigint id PK
        text nama UK
        text slug UK
        timestamptz created_at
    }

    produk {
        bigint id PK
        bigint kategori_id FK
        text sku UK
        text nama
        text satuan
        numeric harga
        integer stok
        boolean aktif
        timestamptz created_at
        timestamptz updated_at
    }

    varian_produk {
        bigint id PK
        bigint produk_id FK
        text ukuran
        text warna
        text sku UK
        numeric harga
        integer stok
        boolean aktif
    }

    pengguna {
        bigint id PK
        text nama
        text email UK
        text password_hash
        text peran
        timestamptz created_at
    }

    pesanan {
        bigint id PK
        text kode UK
        bigint pengguna_id FK
        timestamptz tanggal
        numeric total
        text metode_bayar
        text status
    }

    item_pesanan {
        bigint id PK
        bigint pesanan_id FK
        bigint produk_id FK
        bigint varian_id FK
        integer qty
        numeric harga_satuan
        numeric subtotal
    }

    log_chat {
        bigint id PK
        text sesi_id
        text pertanyaan
        text jawaban
        jsonb sumber
        timestamptz created_at
    }
```
