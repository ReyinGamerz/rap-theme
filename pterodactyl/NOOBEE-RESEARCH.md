# Noobee v1.1.1 — research notes for Rap-theme

Dokumen ini merangkum pola yang dipelajari dari arsip Noobee v1.1.1, lalu membedakan mana yang diadaptasi ke Rap-theme. Tujuannya meniru prinsip implementasi yang baik, bukan menyalin tampilan Noobee.

## Pola yang terlihat di Noobee

- **Global styling:** `GlobalStylesheet.ts` memakai styled-components dan Tailwind helper untuk canvas halaman, tipografi, fokus, input angka, dan scrollbar.
- **Komponen UI reusable:** `Input.tsx`, `ContentBox.tsx`, `TitledGreyBox.tsx`, dan `GreyRowBox.tsx` menjadi pusat styling form/panel.
- **Komposisi route:** router memisahkan navigasi, suspense/loading, permission, dan link yang bergantung pada egg/nest.
- **Baris dashboard server:** `ServerRow.tsx` menggabungkan status, metrik resource, dan alarm threshold; ini perilaku React, bukan sekadar CSS.
- **Console:** `StatBlock.tsx`, `ChartBlock.tsx`, serta `console/style.module.css` membatasi style ke blok metrik/terminal.
- **File manager:** `FileObjectRow.tsx` dan `files/style.module.css` memisahkan layout baris dari data dan aksi.
- **Data server:** `getServer.ts` memetakan data API ke model bertipe, sedangkan `ServerTransformer.php` memasok properti yang dipakai client.

## Cara Rap-theme mengadaptasi pelajaran ini

1. **Palette dibangun ke dalam design tokens Tailwind.** Overlay mengubah skala gray/neutral serta blue/primary/cyan dan token border/radius/shadow pada source Pterodactyl 1.15.1. Halaman yang sudah menggunakan utility class mewarisi palet Rapelz saat build, daripada harus dicat ulang oleh selector substring global.
2. **Global styling tetap berada di layer React.** Variabel CSS Rapelz diimpor lewat entry modular dan canvas utama diatur dari `GlobalStylesheet.ts`.
3. **Komponen tetap punya tanggung jawab sendiri.** Overlay menambahkan marker kecil pada panel/input/baris server/kartu statistik/grafik/file row agar sentuhan tambahan hanya mengenai komponen tersebut.
4. **CSS tambahan terpisah per concern.** `theme/components/` menangani marker komponen, sedangkan `theme/pages/` menangani detail dashboard, console, dan file rows.
5. **Fungsi asli Pterodactyl dipertahankan.** Route, permission, API contract, websocket, tindakan server, dan pemetaan data tidak diganti hanya demi meniru Noobee.

## Status validasi

GitHub Actions menguji overlay pada checkout bersih tag resmi Pterodactyl `v1.15.1`, kemudian menjalankan TypeScript, ESLint, serta webpack production-mode tanpa cleanup. Ini memvalidasi kompatibilitas build di lingkungan CI, tetapi tidak menggantikan smoke test visual/runtime pada staging yang terhubung ke konfigurasi panel yang sebenarnya.

## Batasan

- Tidak ada warna, logo, branding, atau desain Noobee yang disalin.
- Tidak ada addon yang diasumsikan terpasang atau diwajibkan.
- Tidak ada fitur Backup Manager yang ditambahkan ke Pterodactyl.
- PHP transformer atau source React Noobee tidak ditimpa ke panel; implementasi diadaptasi secara terarah terhadap versi target.
- AdminLTE lama tetap menjadi target styling terpisah dari React client.
- Mengubah GitHub tidak otomatis men-deploy ke server produksi.
