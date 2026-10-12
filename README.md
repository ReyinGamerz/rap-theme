# Rapelz Theme

Tema visual navy gelap + electric blue untuk ekosistem Rapelz Hosting.

## Status

- `styles.css` dan `index.html`: prototipe visual **Backup Manager** (data demo, bukan fitur produksi).
- `pterodactyl/react-theme.css`: lapisan CSS visual untuk UI React Pterodactyl 1.15.1.
- `pterodactyl/admin-theme.css`: lapisan CSS visual untuk Admin UI berbasis Blade.
- `pterodactyl/install-theme.sh`: integrasi satu kali dengan pemeriksaan anchor dan backup file sumber/layout yang disentuh.
- `pterodactyl/INSTALL-PTERODACTYL.md`: petunjuk build, staging, aktivasi, dan rollback.

Tema ini hanya mengubah presentasi visual. Tidak menambah route/API/fitur Backup Manager dan tidak mengubah logika autentikasi, console, maupun pengelolaan server.

## Integrasi

Baca [panduan Pterodactyl 1.15.1](pterodactyl/INSTALL-PTERODACTYL.md) terlebih dahulu. Script integrasi tidak menginstal dependency dan tidak menjalankan build. Jalankan pada staging terlebih dahulu; periksa backup yang dibuat dan diff source sebelum build.

**Penting:** script bawaan `yarn build:production` menjalankan `clean` yang menghapus file JavaScript dan source map di `public/assets`. Jangan menjalankannya di produksi sebelum dependensi tersedia, staging build berhasil, dan backup aset dapat dipulihkan.

## Preview prototipe

Buka `index.html` di browser. Halaman itu hanya mockup Backup Manager dengan data simulasi; jangan tautkan atau pasang halaman mockup tersebut ke panel produksi.
