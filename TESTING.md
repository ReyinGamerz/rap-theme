# Testing Rap-theme

Dokumen ini membedakan uji prototipe Backup Manager dari uji rebuild tema Pterodactyl. Keduanya adalah target yang berbeda.

## A. Automated validation — modular Pterodactyl theme

Workflow GitHub Actions pada branch rebuild mengambil source resmi Pterodactyl `v1.15.1` pada runner terisolasi dan menjalankan:

- penerapan overlay, termasuk uji penerapan ulang agar idempotent;
- instalasi dependency memakai `yarn.lock` upstream;
- `yarn tsc`;
- `yarn lint`;
- webpack production-mode tanpa memanggil `build:production` yang menjalankan cleanup aset lebih dahulu.

Hasil build yang sukses memvalidasi kompatibilitas source dan bundling. Itu **tidak** berarti perubahan sudah dideploy atau semua tampilan sudah diuji pada panel live.

## B. Manual runtime smoke test — lakukan di staging

- [ ] Halaman login/auth tampil dengan latar dan kontrol Rapelz.
- [ ] Dashboard terbuka dan baris server memuat status/resource yang benar.
- [ ] Link dashboard/account/server tetap menuju halaman yang benar.
- [ ] Permission route tetap menghalangi halaman yang tidak diizinkan.
- [ ] Server power actions dan websocket tetap berfungsi.
- [ ] Console terminal tetap mempertahankan warna ANSI dan scrollbar yang terbaca.
- [ ] Console statistik/grafik menampilkan nilai yang benar.
- [ ] File manager tetap bisa memilih, membuka, mengunggah, mengganti nama, menghapus, dan menggunakan menu konteks sesuai permission.
- [ ] Input, modal, dropdown, fokus keyboard, dan pesan error dapat digunakan.
- [ ] Layout tetap bisa dipakai pada lebar mobile; tabel/terminal tidak memaksa viewport melebar.
- [ ] AdminLTE/Blade masih terbuka dan memakai tema admin Rapelz.
- [ ] Pengujian dilakukan tanpa addon pihak ketiga terpasang.
- [ ] Tidak ada error baru di console browser atau log panel.

Jangan deploy ke produksi sampai build staging dan smoke test ini lolos.

## C. Prototipe Backup Manager — demo statis terpisah

Halaman `index.html` hanyalah mockup dengan data demo. Untuk memeriksa UI prototipe:

- [ ] Overview dan tabel backup demo terbuka.
- [ ] Filter node/type/status/date/search mengubah data terlihat.
- [ ] Pagination dan sorting dapat dipakai.
- [ ] Navigasi Restore Center, Node & Migration, Schedules, Reports, dan Settings bekerja.
- [ ] Input webhook hanya memvalidasi format dan aksi Save/Test berstatus preview; tidak mengirim webhook sungguhan.
- [ ] Pada layar mobile, sidebar dapat dibuka/tutup dan tabel bisa digulir horizontal.

Prototipe ini tidak memverifikasi backend backup/restore, autentikasi API, migrasi node, atau kesehatan server produksi.
