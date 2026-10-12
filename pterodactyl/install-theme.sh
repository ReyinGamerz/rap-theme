#!/usr/bin/env bash
set -Eeuo pipefail

# Compatibility entry point retained for existing documentation/bookmarks.
# The rebuild now uses a source-level Tailwind palette + modular CSS and
# component-local markers. The actual integration logic lives in one script.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

echo "Rap-theme installer now uses the modular Noobee-inspired source overlay."
echo "It changes only the supplied panel source tree and refuses /var/www/pterodactyl by default."
exec bash "$SCRIPT_DIR/apply-modular-theme.sh" "${1:-}"
