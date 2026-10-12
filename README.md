# Rapelz Theme

Tema Pterodactyl dengan identitas visual Rapelz Hosting: navy gelap, electric blue, dan aksen hijau.

## Status rebuild

Branch **`rebuild/noobee-architecture`** berisi rebuild terarah dengan prinsip implementasi yang dipelajari dari Noobee, tanpa menyalin desain Noobee. Perubahan belum digabung ke `main` dan belum diterapkan ke panel produksi.

- `pterodactyl/theme/`: CSS modular untuk client React: token, global foundation, komponen ber-marker, dashboard, console, dan file manager.
- `pterodactyl/apply-modular-theme.sh`: integrasi source untuk Pterodactyl 1.15.1 dengan pemeriksaan anchor, backup otomatis, serta penolakan path `/var/www/*` secara default.
- `pterodactyl/admin-theme.css` + `pterodactyl/admin/`: entry dan modul CSS terpisah untuk AdminLTE/Blade, memakai token yang sama dengan React.
- `pterodactyl/rollback-modular-theme.sh`: pemulihan source dari backup installer.
- `pterodactyl/react-theme.css`: CSS override lama yang dipertahankan sebagai referensi/rollback; jalur modular tidak mengimpornya.
- `styles.css`, `index.html`, `app.js`: prototipe statis **Backup Manager** dengan data demo; bukan fitur Pterodactyl dan tidak dipasang ke panel.

## Arsitektur

Warna utama dipetakan menjadi token native Tailwind pada build-time, sehingga halaman React yang memakai utility classes menggunakan palet Rapelz. Global canvas tetap ditangani oleh `GlobalStylesheet.ts`, komponen Pterodactyl existing tetap memegang layout dan perilakunya, dan stylesheet tambahan menargetkan marker komponen/page tertentu. AdminLTE memakai berkas terpisah karena berasal dari layout Blade yang berbeda.

Overlay tidak mengubah route, permission, API contract, authentication, websocket, model data, atau tindakan server. Tidak ada addon yang diperlukan, dan tidak ada fitur Backup Manager baru.

## Validasi

GitHub Actions mengambil source resmi `pterodactyl/panel v1.15.1` pada runner terisolasi, menerapkan overlay dua kali untuk mengecek idempotensi, lalu menjalankan TypeScript, ESLint, dan webpack production-mode tanpa menjalankan script `build:production` yang membersihkan aset terlebih dahulu. Lolos CI belum menggantikan uji visual/runtime pada staging yang terhubung ke konfigurasi nyata panel.

## Staging

Baca [panduan integrasi](pterodactyl/INSTALL-PTERODACTYL.md). Jangan menerapkan ke `/var/www/pterodactyl` terlebih dahulu. Build dan smoke test di salinan staging; production deployment membutuhkan backup aset yang dapat dipulihkan.

## Prototipe

`index.html` hanya mockup Backup Manager dengan data simulasi. Jangan tautkan atau pasang mockup tersebut sebagai route Pterodactyl produksi.
