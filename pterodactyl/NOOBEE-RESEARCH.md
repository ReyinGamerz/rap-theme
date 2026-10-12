# Noobee v1.1.1 — research notes for Rap-theme

Dokumen ini merangkum pola dari arsip Noobee v1.1.1 dan adaptasinya pada Rap-theme. Tujuannya menggunakan prinsip engineering yang sama sambil mempertahankan desain Rapelz, bukan menyalin tampilan Noobee.

## Pola Noobee yang dipelajari

- **Global styling:** `GlobalStylesheet.ts` memakai styled-components dan Tailwind untuk canvas, typography, focus, number inputs, dan scrollbar.
- **Reusable primitives:** `Input.tsx`, `ContentBox.tsx`, `TitledGreyBox.tsx`, dan `GreyRowBox.tsx` menyatukan aturan UI umum.
- **Route composition:** router menata navigasi, loading/suspense, permission, dan link berdasarkan konfigurasi.
- **Dashboard server row:** status, metrik resource, dan ambang alarm ditangani sebagai komponen React.
- **Console:** `StatBlock.tsx`, `ChartBlock.tsx`, dan `console/style.module.css` mengisolasi presentasi metrik dan terminal.
- **File manager:** `FileObjectRow.tsx` dan `files/style.module.css` memisahkan baris file dari aksi/data.
- **API data mapping:** client model bertipe dipasangkan dengan data yang disediakan oleh backend transformer.

## Implementasi Rap-theme

1. **Native Tailwind palette:** overlay mengadaptasi palette `gray/neutral` serta `blue/primary/cyan`, border, radius, dan shadow melalui `tailwind.config.js`. Ini mengurangi ketergantungan pada selector global yang menebak nama kelas.
2. **Global styling di layer React:** canvas dan fokus berada di fondasi global yang terpisah dari CSS komponen.
3. **Komponen reusable yang sudah ada dipertahankan:** marker eksplisit ditambahkan ke panel, form controls, baris server, kartu statistik/grafik, dan file row sehingga tema dapat menargetkan hanya komponen terkait.
4. **CSS modular:** gaya React dipisah per concern di `theme/components/` dan `theme/pages/`. Styling AdminLTE juga dibagi ke token, base, dan refinement layer karena targetnya berbeda dengan React client.
5. **Logika aplikasi tetap upstream:** routes, permissions, API, websocket, tindakan server, model data, dan metrik tidak diganti hanya untuk meniru Noobee.

## Automated validation

GitHub Actions menggunakan checkout bersih tag resmi `v1.15.1`, menerapkan source overlay dua kali dan membandingkan diff, lalu menjalankan TypeScript, ESLint, serta webpack production-mode tanpa tahap `clean` yang dipanggil oleh `build:production`. Ini memvalidasi integrasi source/build; uji visual/runtime tetap wajib di staging.

## Batasan

- Tidak ada branding, warna, logo, atau desain Noobee yang disalin.
- Tidak ada addon yang diasumsikan terpasang.
- Tidak ada fitur Backup Manager yang ditambahkan ke Pterodactyl.
- Noobee router/backend transformer tidak ditimpa ke source upstream; hanya prinsip yang relevan yang diadaptasi dengan pemeriksaan versi.
- Perubahan GitHub tidak otomatis men-deploy ke panel produksi.
