# Rapelz theme — Pterodactyl Panel v1.15.1

This is a **visual-only** theme layer for the existing Pterodactyl 1.15.1 React UI and legacy Admin Blade UI. It does not add pages or features and must not be used to install the Backup Manager prototype.

## Files
- `pterodactyl/react-theme.css`: visual overrides for dashboard, authentication and server pages.
- `pterodactyl/admin-theme.css`: visual overrides for the legacy Admin UI.
- `pterodactyl/INSTALL-PTERODACTYL.md`: activation and rollback notes.

## React UI integration
1. Confirm the panel source is exactly v1.15.1. Back up `resources/scripts/components/App.tsx`, `resources/scripts/assets/css/GlobalStylesheet.ts`, and all of `public/assets/`.
2. Copy `react-theme.css` to `resources/scripts/assets/css/rapelz-theme.css`.
3. In `resources/scripts/components/App.tsx`, add this import beside the existing CSS imports (for example, near `import '@/assets/tailwind.css';`):
   `import '@/assets/css/rapelz-theme.css';`
4. Install dependencies using the exact package manager and lockfile supplied by the installed Pterodactyl 1.15.1 source. Do not mix npm-generated lockfiles with `yarn.lock`.
5. Build in a separate staging copy first. Verify the command exits successfully and the generated `public/assets/manifest.json` is valid before deploying the resulting assets.
6. Hard-refresh the browser after deployment.

The import is deliberately an explicit source edit; do not inject it automatically into an unknown source version. The stylesheet only overrides presentation and does not alter routing, authentication, API calls, or server/console behavior.

## Legacy Admin UI integration
1. Back up `resources/views/layouts/admin.blade.php` and the target CSS directory.
2. Copy `admin-theme.css` to `public/themes/pterodactyl/css/rapelz-theme.css`.
3. Open `resources/views/layouts/admin.blade.php`. Find the existing `Theme::css('css/pterodactyl.css')` registration and add the theme immediately after it:
   `{!! Theme::css('css/rapelz-theme.css') !!}`
4. Check the Blade syntax and render an admin page. If the layout in your installation differs, stop and inspect it rather than blindly inserting the line.

## Build and production safety
- Pterodactyl 1.15.1 ships prebuilt frontend assets, while its editable React source is in `resources/scripts`.
- The upstream `build:production` script runs `clean` first and deletes existing JavaScript and source-map files under `public/assets`. **Never run it against production until dependencies are installed, a staging build succeeds, and a restorable asset backup exists.**
- The build tools require Node.js 22 or newer. The exact repository's package scripts and lockfile are authoritative; inspect them before choosing Yarn versus npm.
- Once the React import is present and dependencies are installed, the intended production commands are:
  ```bash
  cd /var/www/pterodactyl
  yarn build:production
  php artisan view:clear
  ```
  This assumes Yarn is installed and dependencies are already available. `view:clear` clears Laravel compiled views; it does not build frontend assets.

## Rollback
- React UI: remove the import from `App.tsx`, remove `rapelz-theme.css`, and restore the saved `public/assets/` backup if needed.
- Admin UI: remove the added Blade CSS line and remove the copied theme CSS file.
- If anything looks wrong, restore the pre-change backups before trying another build.
