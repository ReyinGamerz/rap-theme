# Rapelz Theme

Tema visual navy gelap + electric blue untuk ekosistem Rapelz Hosting.

## Status

- `styles.css` dan `index.html`: prototipe visual **Backup Manager** (data demo, bukan fitur produksi).
- `pterodactyl/react-theme.css`: lapisan CSS visual untuk UI React Pterodactyl 1.15.1 (dashboard, auth, halaman server).
- `pterodactyl/admin-theme.css`: lapisan CSS visual untuk Admin UI berbasis Blade.
- `pterodactyl/INSTALL-PTERODACTYL.md`: petunjuk integrasi manual, build, dan rollback.

Tema Pterodactyl ini hanya mengubah presentasi visual. Tidak menambah route/API/fitur Backup Manager dan tidak mengubah logika autentikasi, console, maupun pengelolaan server.

## Pemasangan

Ikuti [panduan Pterodactyl 1.15.1](pterodactyl/INSTALL-PTERODACTYL.md). Uji build pada salinan staging terlebih dahulu. Jangan jalankan `yarn build:production` pada produksi sebelum dependensi tersedia dan backup aset dapat dipulihkan, karena script bawaan menjalankan `clean` yang menghapus file JavaScript dan source map lama.

## Preview prototipe

Buka `index.html` di browser. Halaman itu hanya mockup Backup Manager dengan data simulasi; jangan tautkan atau pasang halaman mockup tersebut ke panel produksi.
