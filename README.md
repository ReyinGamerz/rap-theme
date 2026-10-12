# Rapelz Theme

Tema Pterodactyl dengan identitas visual Rapelz Hosting: navy gelap, electric blue, dan aksen hijau.

## Status rebuild

Branch **`rebuild/noobee-architecture`** sedang menyiapkan rebuild React theme dengan pola arsitektur yang dipelajari dari Noobee, tetapi tetap mempertahankan desain Rapelz. Perubahan belum digabung ke `main` dan belum diterapkan ke panel produksi.

- `pterodactyl/theme/`: stylesheet modular untuk token, global foundation, komponen yang ditandai, dashboard, console, dan file manager.
- `pterodactyl/apply-modular-theme.sh`: integrasi source bertarget Pterodactyl 1.15.1, dengan backup, pemeriksaan anchor, serta penolakan jalur web-root secara default.
- `pterodactyl/admin-theme.css`: styling terpisah untuk AdminLTE/Blade.
- `pterodactyl/react-theme.css`: stylesheet override lama, dipertahankan sebagai referensi/rollback dan tidak diimpor oleh jalur modular.
- `pterodactyl/INSTALL-PTERODACTYL.md`: petunjuk integrasi staging, pengujian, dan rollback.
- `styles.css` + `index.html`: prototipe statis **Backup Manager** dengan data demo. Prototipe ini bukan fitur Pterodactyl dan tidak dipasang ke panel.

## Pendekatan teknis

Alih-alih menimpa warna semua utility class lewat selector CSS global, overlay memetakan palette Tailwind Pterodactyl ke token Rapelz saat build. Styling tambahan menggunakan GlobalStylesheet React, penanda komponen yang spesifik, dan aturan page-scoped. Komponen, route, permission, API, console/websocket, serta tindakan server asli Pterodactyl dipertahankan.

Tidak ada addon yang dibutuhkan. Tidak ada fitur Backup Manager yang ditambahkan.

## Validasi

GitHub Actions mengambil source resmi Pterodactyl **v1.15.1** pada runner terisolasi, menerapkan overlay, lalu menjalankan TypeScript, ESLint, dan webpack production-mode tanpa menjalankan script `build:production` yang menghapus aset terlebih dahulu. Uji runtime visual tetap perlu dilakukan di panel staging sebelum deployment.

## Integrasi

Baca [panduan Pterodactyl 1.15.1](pterodactyl/INSTALL-PTERODACTYL.md). Untuk staging:

```bash
bash pterodactyl/apply-modular-theme.sh /root/pterodactyl-rapelz-staging
cd /root/pterodactyl-rapelz-staging
corepack yarn tsc
corepack yarn lint
corepack yarn build
```

Jangan jalankan integrasi langsung pada `/var/www/pterodactyl`. Installer menolak jalur web-root kecuali override eksplisit diberikan. Deployment produksi tetap harus memakai backup aset yang bisa dipulihkan dan build staging yang sudah diverifikasi.

## Preview prototipe terpisah

Buka `index.html` di browser untuk melihat mockup Backup Manager berbasis data simulasi. Jangan tautkan atau pasang halaman tersebut sebagai route Pterodactyl produksi.
