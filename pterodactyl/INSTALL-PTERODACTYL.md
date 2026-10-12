# Rapelz Theme — Pterodactyl Panel v1.15.1

Rap-theme is being rebuilt using Noobee-inspired engineering patterns while retaining the Rapelz navy, electric-blue, and green visual identity. The new path uses Tailwind design tokens, Pterodactyl's existing reusable React components, focused component markers, and page-scoped CSS rather than relying on broad selectors matching every Tailwind class.

## What the modular overlay changes

- Maps Tailwind `gray` / `neutral`, `blue` / `primary`, and `cyan` color tokens to the Rapelz palette at build time.
- Keeps the application canvas in Pterodactyl's existing `GlobalStylesheet.ts` React global-style layer.
- Imports the modular CSS entry from `App.tsx` after Tailwind.
- Adds narrowly scoped data/class markers to the existing panel, input, server row, console metrics, chart and file row components.
- Keeps Pterodactyl route handling, permission checks, API calls, websocket/console behavior, actions, and data models intact.
- Leaves the legacy AdminLTE admin UI on its separate Blade stylesheet integration.
- Requires no addons and does not add Backup Manager.

## Important: stage first

Use a **separate source copy** of Pterodactyl 1.15.1. This script refuses `/var/www/pterodactyl` by default and does not run a frontend build.

From the cloned Rap-theme repository, run:

```bash
bash pterodactyl/apply-modular-theme.sh /root/pterodactyl-rapelz-staging
```

The script checks known source anchors, creates a backup outside the panel source (under `/root` when run as root), and patches all expected files only after verifying the source patterns. If the source differs unexpectedly, it stops instead of guessing. Record the printed backup path.

Then validate the staging copy:

```bash
cd /root/pterodactyl-rapelz-staging
corepack yarn tsc
corepack yarn build
```

Use the exact lockfile/package manager belonging to the panel source. Do not run a production build on the live panel. Upstream `build:production` runs `clean` first and removes generated JavaScript/source maps from `public/assets`; a verified staging build and restorable asset backup are mandatory before any production deployment.

## Manual smoke test after a successful staging build

Check login/auth screens, dashboard rows and live resource metrics, account navigation, server navigation/permissions, console and terminal ANSI colors, power buttons, file manager actions and permissions, inputs/forms, mobile-width layouts, plus the legacy admin panel. Verify with no add-ons installed.

## Rollback

The script prints a timestamped backup directory. Restore the backed-up versions of the files listed below, plus the previous modular CSS destination if present:

- `tailwind.config.js`
- `resources/scripts/components/App.tsx`
- `resources/scripts/assets/css/GlobalStylesheet.ts`
- the marked reusable/dashboard/console/file React component sources
- `resources/views/layouts/admin.blade.php`
- `resources/scripts/assets/css/rapelz-theme/`
- `public/themes/pterodactyl/css/rapelz-theme.css`

Alternatively, in the staging copy, discard that copy and recreate it from a clean Pterodactyl 1.15.1 source tree.

## Legacy behavior

`pterodactyl/react-theme.css` is retained as a reference/rollback stylesheet; the modular installer no longer imports it. The `pterodactyl/install-theme.sh` filename remains as a compatibility entry point, but it delegates to the staging-first modular installer.
