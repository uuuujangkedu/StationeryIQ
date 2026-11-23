# Kanban — StationeryIQ

> **Board resmi:** GitHub Projects **"StationeryIQ MVP Board"** (owner `uuuujangkedu`),
> ter-link ke repo ini — https://github.com/users/uuuujangkedu/projects/1
> File ini snapshot status; sumber kebenaran = board. Lihat [`README.md`](README.md) untuk ketergantungan antar peran.

## Backlog

| ID | PIC | Periode | Prioritas | Tugas |
|---|---|---|---|---|
| TSK-FS-05 | Rafi & Rizki | Minggu 3 | Tinggi | Integrasi frontend + backend + DB + RAG (end-to-end staging) |
| TSK-FS-06 | Rafi | Minggu 3 | Tinggi | Tes E2E, validasi input ekstrem, bug fixing |
| TSK-FS-07 | Rizki | Minggu 4 | Tinggi | Deployment prototipe ke staging/production |
| TSK-FS-08 | Rafi & Rizki | Minggu 4 | Tinggi | UAT dengan pemilik toko + final fix |
| TSK-FS-09 | Rafi | Minggu 4 | Sedang | User Manual (PDF/MD + screenshot) |
| TSK-FS-10 | Rizki | Pasca-MVP | Sedang | Dashboard admin CRUD stok + transaksi + login |

## To Do (Minggu berjalan)

| ID | PIC | Prioritas | Tugas |
|---|---|---|---|
| — | Rizki | Tinggi | Kontrak JSON katalog + interface RAG (koordinasi DS & GenAI) |

## In Progress

| ID | PIC | Prioritas | Tugas | Catatan |
|---|---|---|---|---|
| TSK-FS-01 | Rafi | Sedang | Setup repo, branching, environment, **board** | repo/CI/branching ✔; board (GitHub Project) ✔ |
| TSK-FS-04 | Rizki | Tinggi | REST API penghubung frontend–DB | `/stok` & `/kategori` sudah baca Supabase; tinggal poles + error handling |

## Review

_(kosong)_

## Done

| ID | PIC | Periode | Deliverable |
|---|---|---|---|
| TSK-FS-02 | Rizki | Minggu 1 | Wireframe UI chat (disetujui tim) + skeleton FastAPI & frontend |
| — | — | Minggu 1 | Repo GitHub + README + aturan branching (push langsung) |
| — | — | Minggu 1 | CI dasar (lint + test) via GitHub Actions |
| — | — | Minggu 1 | Supabase tersambung (mode `supabase`) |
| — | — | Minggu 1 | Uji E2E frontend ↔ API (semua endpoint 200) |
| — | — | Minggu 1 | Kanban GitHub Projects "StationeryIQ MVP Board" dibuat + 15 kartu |
| — | — | Minggu 2 | Deploy backend live di Railway (Docker) — https://stationeryiq-production.up.railway.app |

## Dibuat sebagai GitHub Project

Board sudah dibuat + 15 kartu, kolom Status terisi (Todo 7 / In Progress 2 / Done 6):

- Project: https://github.com/users/uuuujangkedu/projects/1
- Kartu draft (DraftIssue): judul = ID + tugas, body = PIC · periode · prioritas.

Kelola via web, atau CLI:

```powershell
gh project list --owner uuuujangkedu
gh project item-list 1 --owner uuuujangkedu
gh project item-create 1 --owner uuuujangkedu --title "TSK-FS-xx ..." --body "PIC: ... · Minggu N · Prioritas"
```
