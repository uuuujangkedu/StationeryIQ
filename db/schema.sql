-- StationeryIQ — skema inventaris Toko Anugerah (PostgreSQL / Supabase)
-- Pemilik wilayah: path Data Science. Lihat docs/CONTRACT.md §A.
--
-- Kompatibilitas: backend/db.py melakukan `select *` pada tabel `products`
-- dan mengharapkan kolom { id, nama, kategori, stok, harga }. View `products`
-- di bawah menyajikan bentuk itu dari tabel ternormalisasi, sehingga
-- endpoint /stok & /kategori tetap jalan tanpa mengubah kode backend.

-- ============================================================ katalog

create table if not exists kategori (
  id         bigint generated always as identity primary key,
  nama       text not null unique,
  slug       text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists produk (
  id          bigint generated always as identity primary key,
  sku         text unique,
  nama        text not null,
  kategori_id bigint not null references kategori (id) on delete restrict,
  satuan      text not null default 'pcs',
  harga       numeric(12, 2) not null check (harga >= 0),
  stok        integer not null default 0 check (stok >= 0),
  aktif       boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Varian untuk barang ber-ukuran/warna (mis. seragam). Produk tanpa varian
-- memakai kolom produk.stok apa adanya (lihat view `products`).
create table if not exists varian_produk (
  id        bigint generated always as identity primary key,
  produk_id bigint not null references produk (id) on delete cascade,
  ukuran    text,
  warna     text,
  sku       text unique,
  harga     numeric(12, 2) check (harga >= 0),
  stok      integer not null default 0 check (stok >= 0),
  aktif     boolean not null default true,
  unique (produk_id, ukuran, warna)
);

-- ============================================================ transaksi

create table if not exists pengguna (
  id            bigint generated always as identity primary key,
  nama          text not null,
  email         text not null unique,
  password_hash text not null,
  peran         text not null default 'kasir' check (peran in ('pemilik', 'kasir')),
  created_at    timestamptz not null default now()
);

create table if not exists pesanan (
  id           bigint generated always as identity primary key,
  kode         text not null unique,
  pengguna_id  bigint references pengguna (id) on delete set null,
  tanggal      timestamptz not null default now(),
  total        numeric(14, 2) not null default 0 check (total >= 0),
  metode_bayar text not null default 'tunai',
  status       text not null default 'selesai' check (status in ('draft', 'selesai', 'batal'))
);

create table if not exists item_pesanan (
  id           bigint generated always as identity primary key,
  pesanan_id   bigint not null references pesanan (id) on delete cascade,
  produk_id    bigint not null references produk (id) on delete restrict,
  varian_id    bigint references varian_produk (id) on delete set null,
  qty          integer not null check (qty > 0),
  harga_satuan numeric(12, 2) not null check (harga_satuan >= 0),
  subtotal     numeric(14, 2) generated always as (qty * harga_satuan) stored
);

-- ============================================================ log RAG (M3)

create table if not exists log_chat (
  id         bigint generated always as identity primary key,
  sesi_id    text,
  pertanyaan text not null,
  jawaban    text,
  sumber     jsonb,
  created_at timestamptz not null default now()
);

-- ============================================================ index FK

create index if not exists idx_produk_kategori  on produk (kategori_id);
create index if not exists idx_varian_produk    on varian_produk (produk_id);
create index if not exists idx_pesanan_pengguna on pesanan (pengguna_id);
create index if not exists idx_item_pesanan_order on item_pesanan (pesanan_id);
create index if not exists idx_item_pesanan_produk on item_pesanan (produk_id);

-- ============================================================ compat view

-- Bentuk yang dibaca backend: { id, nama, kategori, stok, harga, satuan }.
-- Stok = jumlah varian bila ada varian aktif, selain itu produk.stok.
create or replace view products as
select
  p.id,
  p.nama,
  k.nama as kategori,
  coalesce(sum(v.stok), p.stok)::int as stok,
  p.harga,
  p.satuan
from produk p
join kategori k on k.id = p.kategori_id
left join varian_produk v on v.produk_id = p.id and v.aktif
where p.aktif
group by p.id, k.nama;

-- Grant baca untuk backend (service_role) & anon bila perlu:
--   grant select on products, kategori, produk, varian_produk to service_role;
