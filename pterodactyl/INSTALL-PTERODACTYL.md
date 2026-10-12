# Rapelz theme — Pterodactyl Panel v1.15.1

This is a **visual-only** theme layer for the existing Pterodactyl 1.15.1 React UI and legacy Admin Blade UI. It does not add pages or features and must not be used to install the Backup Manager prototype.

## Files
- `pterodactyl/react-theme.css`: visual overrides for dashboard, authentication and server pages.
- `pterodactyl/admin-theme.css`: visual overrides for the legacy Admin UI.
- `pterodactyl/INSTALL-PTERODACTYL.md`: activation and rollback notes.

## React theme integration
1. Confirm the panel source is exactly v1.15.1 and take a backup of `resources/scripts/components/App.tsx`, `resources/scripts/assets/css/GlobalStylesheet.ts`, and `public/assets/`.
2. Copy `react-theme.css` to `resources/scripts/assets/css/rapelz-theme.css`.
3. Add this import to `resources/scripts/components/App.tsx` alongside the existing CSS imports:
   `import '@/assets/css/rapelz-theme.css';`
4. Install dependencies from the repository lockfile in the panel source directory, then build in a staging copy first.
5. If the build succeeds and the generated `public/assets/manifest.json` is valid, deploy the generated assets and hard-refresh the browser.

The import is deliberately an explicit source edit; do not inject it automatically into an unknown source version.

## Build notes
- Pterodactyl 1.15.1 ships prebuilt frontend assets, while its source is in `resources/scripts`.
- Use the exact version's lockfile and package manager consistently. Do not mix npm-generated lockfiles with `yarn.lock`.
- The upstream `build:production` script runs `clean` first and deletes existing JavaScript and source-map files under `public/assets`. **Never run it against production until dependencies are installed, a staging build succeeds, and a full restorable asset backup exists.**
- After the source import is added, the user's intended production commands are:
  ```bash
  cd /var/www/pterodactyl
  yarn build:production
  php artisan view:clear
  ```
  This assumes Yarn dependencies are already installed and the theme import is present. `view:clear` clears Laravel compiled views; it does not build frontend assets.

## Admin UI
Use the separate Admin CSS activation steps in the installation guide. Keep this activation separate from the React CSS import.

## Rollback
Remove the CSS import from `App.tsx`, remove the copied `rapelz-theme.css`, rebuild using the matching lockfile, and restore the saved `public/assets/` backup if the build/deployment fails. Restore the original Admin Blade link if it was modified.
