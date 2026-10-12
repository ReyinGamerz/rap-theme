#!/usr/bin/env bash
set -Eeuo pipefail

# Roll back a modular Rap-theme source integration using the exact backup path
# printed by apply-modular-theme.sh.
#
# Usage:
#   bash pterodactyl/rollback-modular-theme.sh /root/pterodactyl-rapelz-staging /root/rapelz-theme-rebuild-backup-YYYYMMDD-HHMMSS
#
# Production web roots are blocked unless RAPELZ_ALLOW_PRODUCTION=1 is set.

PANEL_DIR="${1:-}"
BACKUP_DIR="${2:-}"

if [[ -z "$PANEL_DIR" || -z "$BACKUP_DIR" || ! -d "$PANEL_DIR" || ! -d "$BACKUP_DIR" ]]; then
    echo "Usage: $0 /path/to/pterodactyl-staging /path/to/rapelz-theme-rebuild-backup"
    exit 2
fi

PANEL_DIR="$(cd -- "$PANEL_DIR" && pwd -P)"
BACKUP_DIR="$(cd -- "$BACKUP_DIR" && pwd -P)"

case "$PANEL_DIR" in
    /var/www/*)
        if [[ "${RAPELZ_ALLOW_PRODUCTION:-0}" != "1" ]]; then
            echo "ERROR: rollback of a web-root path is blocked by default: $PANEL_DIR"
            echo "For an intentional emergency production rollback, set RAPELZ_ALLOW_PRODUCTION=1."
            exit 10
        fi
        ;;
esac

case "$(basename "$BACKUP_DIR")" in
    rapelz-theme-rebuild-backup-*) ;;
    *)
        echo "ERROR: backup folder name is not a Rap-theme rebuild backup: $BACKUP_DIR"
        exit 3
        ;;
esac

restore_or_remove() {
    local relative="$1"
    local saved="$BACKUP_DIR/$relative"
    local target="$PANEL_DIR/$relative"

    if [[ -e "$saved" ]]; then
        rm -rf "$target"
        mkdir -p "$(dirname "$target")"
        cp -a "$saved" "$target"
        echo "RESTORED $relative"
    else
        rm -rf "$target"
        echo "REMOVED generated target $relative (no prior version was backed up)"
    fi
}

# Source files that the overlay edits. These must exist in a valid backup.
for relative in \
    tailwind.config.js \
    resources/scripts/assets/css/GlobalStylesheet.ts \
    resources/scripts/components/App.tsx \
    resources/scripts/components/elements/ContentBox.tsx \
    resources/scripts/components/elements/Input.tsx \
    resources/scripts/components/elements/GreyRowBox.tsx \
    resources/scripts/components/elements/TitledGreyBox.tsx \
    resources/scripts/components/dashboard/ServerRow.tsx \
    resources/scripts/components/server/console/StatBlock.tsx \
    resources/scripts/components/server/console/ChartBlock.tsx \
    resources/scripts/components/server/files/FileObjectRow.tsx \
    resources/views/layouts/admin.blade.php; do
    if [[ ! -f "$BACKUP_DIR/$relative" ]]; then
        echo "ERROR: required rollback file is missing: $BACKUP_DIR/$relative"
        echo "No rollback changes made."
        exit 4
    fi
done

echo "Restoring Rap-theme rebuild backup..."
for relative in \
    tailwind.config.js \
    resources/scripts/assets/css/GlobalStylesheet.ts \
    resources/scripts/components/App.tsx \
    resources/scripts/components/elements/ContentBox.tsx \
    resources/scripts/components/elements/Input.tsx \
    resources/scripts/components/elements/GreyRowBox.tsx \
    resources/scripts/components/elements/TitledGreyBox.tsx \
    resources/scripts/components/dashboard/ServerRow.tsx \
    resources/scripts/components/server/console/StatBlock.tsx \
    resources/scripts/components/server/console/ChartBlock.tsx \
    resources/scripts/components/server/files/FileObjectRow.tsx \
    resources/views/layouts/admin.blade.php \
    resources/scripts/assets/css/rapelz-theme.css \
    resources/scripts/assets/css/rapelz-theme \
    public/themes/pterodactyl/css/rapelz-theme.css \
    public/themes/pterodactyl/css/rapelz-admin; do
    restore_or_remove "$relative"
done

echo
echo "Rollback source restoration complete."
echo "If this was a staging tree, run corepack yarn tsc and corepack yarn build if you need to regenerate staging assets."
echo "No build has been run by this rollback script. Production assets should be restored separately from their saved public/assets backup if they were replaced."
