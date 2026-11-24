-- Seed awal StationeryIQ. Muat setelah db/schema.sql.
-- Isi kategori harus sama dengan daftar di docs/CONTRACT.md §A.3.

insert into kategori (nama, slug) values
  ('Alat Tulis',        'alat-tulis'),
  ('Buku & Kertas',     'buku-kertas'),
  ('Seragam Sekolah',   'seragam-sekolah'),
  ('Perlengkapan Lain', 'perlengkapan-lain')
on conflict (slug) do nothing;

-- Produk tanpa varian.
insert into produk (sku, nama, kategori_id, satuan, harga, stok)
select v.sku, v.nama, k.id, v.satuan, v.harga, v.stok
from (values
  ('ATK-BP-01', 'Bolpoin Hitam',          'Alat Tulis',      'pcs', 3500::numeric,  24),
  ('BUK-38-01', 'Buku Tulis 38 lembar',   'Buku & Kertas',   'pcs', 4000::numeric, 120)
) as v(sku, nama, kategori, satuan, harga, stok)
join kategori k on k.nama = v.kategori
on conflict (sku) do nothing;

-- Produk ber-varian (seragam).
insert into produk (sku, nama, kategori_id, satuan, harga, stok)
select 'SRG-SD-01', 'Seragam SD Merah Putih', k.id, 'set', 75000::numeric, 0
from kategori k where k.nama = 'Seragam Sekolah'
on conflict (sku) do nothing;

insert into varian_produk (produk_id, ukuran, warna, sku, stok)
select p.id, v.ukuran, 'Merah Putih', 'SRG-SD-01-' || v.ukuran, v.stok
from (values ('S', 3), ('M', 8), ('L', 5)) as v(ukuran, stok)
join produk p on p.sku = 'SRG-SD-01'
on conflict (produk_id, ukuran, warna) do nothing;

-- Cek cepat: select * from products order by id;
