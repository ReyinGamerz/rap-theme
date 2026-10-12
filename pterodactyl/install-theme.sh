#!/usr/bin/env bash
set -Eeuo pipefail

# One-time Rapelz theme integration for an existing Pterodactyl Panel v1.15.1 source tree.
# Usage: sudo bash pterodactyl/install-theme.sh /var/www/pterodactyl
# This script backs up touched source/layout files before modifying them.
# It does NOT install dependencies or run a build.

PANEL_DIR="${1:-}"
if [[ -z "$PANEL_DIR" || ! -d "$PANEL_DIR" ]]; then
  echo "Usage: $0 /path/to/pterodactyl"
  exit 2
fi
cd "$PANEL_DIR"

for required in package.json yarn.lock resources/scripts/components/App.tsx resources/views/layouts/admin.blade.php; do
  if [[ ! -f "$required" ]]; then
    echo "ERROR: required file missing: $PANEL_DIR/$required"
    exit 3
  fi
done

if ! grep -q "import '@/assets/tailwind.css';" resources/scripts/components/App.tsx; then
  echo "ERROR: App.tsx does not match the expected Pterodactyl 1.15.1 import anchor."
  echo "No files changed. Inspect the source version before continuing."
  exit 4
fi

if [[ ! -f "$(dirname "$0")/react-theme.css" || ! -f "$(dirname "$0")/admin-theme.css" ]]; then
  echo "ERROR: run this script from a cloned rap-theme repo, or ensure pterodactyl/react-theme.css and admin-theme.css exist."
  exit 5
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="/root/rapelz-theme-source-backup-$STAMP"
mkdir -p "$BACKUP_DIR"
cp -a resources/scripts/components/App.tsx "$BACKUP_DIR/App.tsx"
cp -a resources/views/layouts/admin.blade.php "$BACKUP_DIR/admin.blade.php"
if [[ -f public/themes/pterodactyl/css/rapelz-theme.css ]]; then
  cp -a public/themes/pterodactyl/css/rapelz-theme.css "$BACKUP_DIR/rapelz-theme.css.previous"
fi

mkdir -p resources/scripts/assets/css public/themes/pterodactyl/css
install -m 0644 "$(dirname "$0")/react-theme.css" resources/scripts/assets/css/rapelz-theme.css
install -m 0644 "$(dirname "$0")/admin-theme.css" public/themes/pterodactyl/css/rapelz-theme.css

if ! grep -q "import '@/assets/css/rapelz-theme.css';" resources/scripts/components/App.tsx; then
  sed -i "/import '@\/assets\/tailwind.css';/a import '@/assets/css/rapelz-theme.css';" resources/scripts/components/App.tsx
fi

if ! grep -q "Theme::css('css/rapelz-theme.css" resources/views/layouts/admin.blade.php; then
  if grep -q "Theme::css('css/pterodactyl.css?t={cache-version}')" resources/views/layouts/admin.blade.php; then
    sed -i "/Theme::css('css\/pterodactyl.css?t={cache-version}')/a\\            {!! Theme::css('css/rapelz-theme.css?t={cache-version}') !!}" resources/views/layouts/admin.blade.php
  elif grep -q "Theme::css('css/pterodactyl.css')" resources/views/layouts/admin.blade.php; then
    sed -i "/Theme::css('css\/pterodactyl.css')/a\\            {!! Theme::css('css/rapelz-theme.css') !!}" resources/views/layouts/admin.blade.php
  else
    echo "ERROR: could not find expected admin CSS registration."
    echo "Restore from $BACKUP_DIR if needed; do not build until the layout is reviewed."
    exit 6
  fi
fi

echo "Rapelz source integration complete."
echo "Backups: $BACKUP_DIR"
echo "Next: build and verify in a separate staging copy before production."
echo "WARNING: yarn build:production runs clean and deletes existing JS/maps in public/assets."
