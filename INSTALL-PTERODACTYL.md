# Panduan instalasi theme admin Rapelz

Panduan pemasangan dilakukan manual setelah backup dan pemeriksaan layout. File CSS ini hanya untuk tampilan admin; tidak mengubah route, API, auth, database, Wings, atau menambah Backup Manager.

## Ambil repo

```bash
cd /root
if [ ! -d rap-theme ]; then git clone https://github.com/ReyinGamerz/rap-theme.git; else git -C /root/rap-theme pull --ff-only; fi
```

## Salin CSS setelah diperiksa

```bash
cd /var/www/pterodactyl || exit 1
THEME_SRC=/root/rap-theme/pterodactyl/admin-theme.css
THEME_DST=public/themes/pterodactyl/css/rapelz-theme.css
test -s "$THEME_SRC" || { echo 'STOP: sumber CSS tidak ditemukan'; exit 1; }
test -s public/themes/pterodactyl/css/pterodactyl.css || { echo 'STOP: CSS bawaan tidak ditemukan'; exit 1; }
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="/root/rapelz-theme-backup/rapelz-theme-$STAMP"
mkdir -p "$BACKUP"
cp -a public/themes/pterodactyl/css/pterodactyl.css "$BACKUP/"
if [ -e "$THEME_DST" ]; then cp -a "$THEME_DST" "$BACKUP/"; fi
install -m 0644 "$THEME_SRC" "$THEME_DST"
printf 'CSS theme tersalin. Backup CSS bawaan ada di %s\n' "$BACKUP"
```

## Aktivasi harus dilakukan terpisah

Belum ada perubahan otomatis ke Blade karena setiap instalasi bisa punya konteks berbeda. Backup dulu `resources/views/layouts/admin.blade.php`, periksa lokasi stylesheet dengan:

```bash
grep -n -C 3 'pterodactyl.css' /var/www/pterodactyl/resources/views/layouts/admin.blade.php
```

Tambahkan link stylesheet baru setelah `css/pterodactyl.css` menggunakan helper `Theme::css` yang sama seperti file bawaan. Jangan menimpa seluruh Blade dan pastikan stylesheet Rapelz dimuat paling akhir. Uji halaman admin/login sebelum menganggap selesai.

## Rollback

Hapus/komentari hanya link stylesheet Rapelz dari Blade lalu hapus `public/themes/pterodactyl/css/rapelz-theme.css`. Pulihkan salinan Blade bila perlu. Jangan hapus stylesheet bawaan. Prototipe `index.html` adalah demo Backup Manager dengan data simulasi dan jangan dipasang ke panel produksi.
