#!/usr/bin/env bash
set -Eeuo pipefail

# Apply the Noobee-inspired, Rapelz-branded source integration to a Pterodactyl
# Panel 1.15.1 source tree. This script deliberately does not run a build.
#
# Usage (staging only):
#   bash pterodactyl/apply-modular-theme.sh /root/pterodactyl-rapelz-staging
#
# Production is refused by default. Never run a production build until staging
# passes TypeScript + webpack validation and a public/assets backup exists.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
PANEL_DIR="${1:-}"

if [[ -z "$PANEL_DIR" || ! -d "$PANEL_DIR" ]]; then
    echo "Usage: $0 /path/to/pterodactyl-staging"
    exit 2
fi

PANEL_DIR="$(cd -- "$PANEL_DIR" && pwd -P)"
case "$PANEL_DIR" in
    /var/www/*)
        if [[ "${RAPELZ_ALLOW_PRODUCTION:-0}" != "1" ]]; then
            echo "ERROR: web-root path refused by default: $PANEL_DIR"
            echo "Run this on the staging copy first. Web-root installs require explicit RAPELZ_ALLOW_PRODUCTION=1."
            exit 10
        fi
        ;;
esac

required=(
    package.json
    yarn.lock
    tailwind.config.js
    resources/scripts/components/App.tsx
    resources/scripts/assets/css/GlobalStylesheet.ts
    resources/scripts/components/elements/ContentBox.tsx
    resources/scripts/components/elements/Input.tsx
    resources/scripts/components/elements/GreyRowBox.tsx
    resources/scripts/components/elements/TitledGreyBox.tsx
    resources/scripts/components/dashboard/ServerRow.tsx
    resources/scripts/components/server/console/StatBlock.tsx
    resources/scripts/components/server/console/ChartBlock.tsx
    resources/scripts/components/server/files/FileObjectRow.tsx
    resources/views/layouts/admin.blade.php
)

for file in "${required[@]}"; do
    if [[ ! -f "$PANEL_DIR/$file" ]]; then
        echo "ERROR: missing expected Pterodactyl source file: $file"
        exit 3
    fi
done

if ! grep -q '"name"[[:space:]]*:[[:space:]]*"pterodactyl-panel"' "$PANEL_DIR/package.json"; then
    echo "ERROR: package.json does not identify a Pterodactyl Panel source tree."
    exit 4
fi

if ! grep -q "import '@/assets/tailwind.css';" "$PANEL_DIR/resources/scripts/components/App.tsx"; then
    echo "ERROR: App.tsx does not contain the expected v1.15.1 Tailwind import anchor."
    echo "No source files changed. Inspect the source version before continuing."
    exit 5
fi

if [[ ! -s "$SCRIPT_DIR/theme/entry.css" || ! -s "$SCRIPT_DIR/admin-theme.css" || ! -s "$SCRIPT_DIR/admin/tokens.css" || ! -s "$SCRIPT_DIR/admin/base.css" || ! -s "$SCRIPT_DIR/admin/refinements.css" ]]; then
    echo "ERROR: React or modular AdminLTE stylesheet files are missing from the rap-theme repository."
    exit 6
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    BACKUP_BASE="/root"
else
    BACKUP_BASE="${TMPDIR:-/tmp}"
fi
BACKUP_DIR="$BACKUP_BASE/rapelz-theme-rebuild-backup-$STAMP"
mkdir -p "$BACKUP_DIR"

backup_one() {
    local relative="$1"
    if [[ -e "$PANEL_DIR/$relative" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
        cp -a "$PANEL_DIR/$relative" "$BACKUP_DIR/$relative"
    fi
}
for file in "${required[@]}"; do backup_one "$file"; done
backup_one "resources/scripts/assets/css/rapelz-theme.css"
backup_one "resources/scripts/assets/css/rapelz-theme"
backup_one "public/themes/pterodactyl/css/rapelz-theme.css"
backup_one "public/themes/pterodactyl/css/rapelz-admin"

echo "Applying version-checked source changes..."
python3 - "$PANEL_DIR" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])

def read(rel):
    p = root / rel
    if not p.is_file():
        raise RuntimeError(f"Required file missing: {rel}")
    return p.read_text(encoding="utf-8")

def replace_once(text, pattern, replacement, label, flags=0):
    updated, count = re.subn(pattern, replacement, text, count=1, flags=flags)
    if count != 1:
        raise RuntimeError(f"Source anchor mismatch in {label}; expected exactly one match, got {count}. No source files written.")
    return updated

changes = {}

# Tailwind utility palettes become the native Rapelz design tokens. This avoids
# recoloring every page with broad global CSS selectors.
rel = "tailwind.config.js"
text = read(rel)
marker = "/* RAPELZ THEME TOKENS v1 */"
if marker not in text:
    palette = """/* RAPELZ THEME TOKENS v1 */
const rapelzGray = {
    50: 'rgb(var(--rap-gray-50) / <alpha-value>)',
    100: 'rgb(var(--rap-gray-100) / <alpha-value>)',
    200: 'rgb(var(--rap-gray-200) / <alpha-value>)',
    300: 'rgb(var(--rap-gray-300) / <alpha-value>)',
    400: 'rgb(var(--rap-gray-400) / <alpha-value>)',
    500: 'rgb(var(--rap-gray-500) / <alpha-value>)',
    600: 'rgb(var(--rap-gray-600) / <alpha-value>)',
    700: 'rgb(var(--rap-gray-700) / <alpha-value>)',
    800: 'rgb(var(--rap-gray-800) / <alpha-value>)',
    900: 'rgb(var(--rap-gray-900) / <alpha-value>)',
    950: 'rgb(var(--rap-gray-950) / <alpha-value>)',
};

const rapelzBlue = {
    50: 'rgb(var(--rap-blue-50) / <alpha-value>)',
    100: 'rgb(var(--rap-blue-100) / <alpha-value>)',
    200: 'rgb(var(--rap-blue-200) / <alpha-value>)',
    300: 'rgb(var(--rap-blue-300) / <alpha-value>)',
    400: 'rgb(var(--rap-blue-400) / <alpha-value>)',
    500: 'rgb(var(--rap-blue-500) / <alpha-value>)',
    600: 'rgb(var(--rap-blue-600) / <alpha-value>)',
    700: 'rgb(var(--rap-blue-700) / <alpha-value>)',
    800: 'rgb(var(--rap-blue-800) / <alpha-value>)',
    900: 'rgb(var(--rap-blue-900) / <alpha-value>)',
    950: 'rgb(var(--rap-blue-950) / <alpha-value>)',
};

const rapelzGreen = {
    50: 'rgb(var(--rap-green-50) / <alpha-value>)',
    100: 'rgb(var(--rap-green-100) / <alpha-value>)',
    200: 'rgb(var(--rap-green-200) / <alpha-value>)',
    300: 'rgb(var(--rap-green-300) / <alpha-value>)',
    400: 'rgb(var(--rap-green-400) / <alpha-value>)',
    500: 'rgb(var(--rap-green-500) / <alpha-value>)',
    600: 'rgb(var(--rap-green-600) / <alpha-value>)',
    700: 'rgb(var(--rap-green-700) / <alpha-value>)',
    800: 'rgb(var(--rap-green-800) / <alpha-value>)',
    900: 'rgb(var(--rap-green-900) / <alpha-value>)',
    950: 'rgb(var(--rap-green-950) / <alpha-value>)',
};

const rapelzRed = {
    50: 'rgb(var(--rap-red-50) / <alpha-value>)',
    100: 'rgb(var(--rap-red-100) / <alpha-value>)',
    200: 'rgb(var(--rap-red-200) / <alpha-value>)',
    300: 'rgb(var(--rap-red-300) / <alpha-value>)',
    400: 'rgb(var(--rap-red-400) / <alpha-value>)',
    500: 'rgb(var(--rap-red-500) / <alpha-value>)',
    600: 'rgb(var(--rap-red-600) / <alpha-value>)',
    700: 'rgb(var(--rap-red-700) / <alpha-value>)',
    800: 'rgb(var(--rap-red-800) / <alpha-value>)',
    900: 'rgb(var(--rap-red-900) / <alpha-value>)',
    950: 'rgb(var(--rap-red-950) / <alpha-value>)',
};

const rapelzAmber = {
    50: 'rgb(var(--rap-amber-50) / <alpha-value>)',
    100: 'rgb(var(--rap-amber-100) / <alpha-value>)',
    200: 'rgb(var(--rap-amber-200) / <alpha-value>)',
    300: 'rgb(var(--rap-amber-300) / <alpha-value>)',
    400: 'rgb(var(--rap-amber-400) / <alpha-value>)',
    500: 'rgb(var(--rap-amber-500) / <alpha-value>)',
    600: 'rgb(var(--rap-amber-600) / <alpha-value>)',
    700: 'rgb(var(--rap-amber-700) / <alpha-value>)',
    800: 'rgb(var(--rap-amber-800) / <alpha-value>)',
    900: 'rgb(var(--rap-amber-900) / <alpha-value>)',
    950: 'rgb(var(--rap-amber-950) / <alpha-value>)',
};

const rapelzBorder = {
    50: 'rgb(var(--rap-border-50) / <alpha-value>)',
    100: 'rgb(var(--rap-border-100) / <alpha-value>)',
    200: 'rgb(var(--rap-border-200) / <alpha-value>)',
    300: 'rgb(var(--rap-border-300) / <alpha-value>)',
    400: 'rgb(var(--rap-border-400) / <alpha-value>)',
    500: 'rgb(var(--rap-border-500) / <alpha-value>)',
    600: 'rgb(var(--rap-border-600) / <alpha-value>)',
    700: 'rgb(var(--rap-border-700) / <alpha-value>)',
    800: 'rgb(var(--rap-border-800) / <alpha-value>)',
    900: 'rgb(var(--rap-border-900) / <alpha-value>)',
    950: 'rgb(var(--rap-border-950) / <alpha-value>)',
};
"""
    text = replace_once(
        text,
        r"const colors = require\('tailwindcss/colors'\);\s*const gray = \{.*?\n\};",
        lambda _m: palette.rstrip(),
        rel,
        flags=re.S,
    )
    colors_block = """colors: {
                black: 'rgb(var(--rap-black) / <alpha-value>)',
                blue: rapelzBlue,
                primary: rapelzBlue,
                gray: rapelzGray,
                neutral: rapelzGray,
                cyan: rapelzBlue,
                green: rapelzGreen,
                emerald: rapelzGreen,
                red: rapelzRed,
                yellow: rapelzAmber,
                amber: rapelzAmber,
            },"""
    text = replace_once(
        text,
        r"colors:\s*\{\s*black:\s*'#131a20',.*?cyan:\s*colors\.cyan,\s*\},",
        lambda _m: colors_block,
        rel,
        flags=re.S,
    )
    text = replace_once(
        text,
        r"borderColor:\s*theme\s*=>\s*\(\{\s*default:\s*theme\('colors\.neutral\.400',\s*'currentColor'\),\s*\}\),",
        "borderColor: theme => ({\n                default: 'var(--rap-line)',\n                neutral: rapelzBorder,\n                gray: rapelzBorder,\n            }),",
        rel,
        flags=re.S,
    )
    # Radius and shadow utilities are first-class tokens too, replacing the
    # prior broad selectors that forced radius/shadow on arbitrary elements.
    text = replace_once(
        text,
        r"(\s*fontSize:\s*\{)",
        lambda m: "\n            borderRadius: {\n                DEFAULT: 'var(--rap-radius-md)',\n                none: '0px',\n                sm: 'var(--rap-radius-sm)',\n                md: 'var(--rap-radius-md)',\n                lg: 'var(--rap-radius-md)',\n                xl: 'var(--rap-radius-md)',\n                '2xl': 'var(--rap-radius-lg)',\n                full: '9999px',\n            },\n            boxShadow: {\n                sm: 'var(--rap-shadow-sm)',\n                DEFAULT: 'var(--rap-shadow-md)',\n                md: 'var(--rap-shadow-md)',\n                lg: 'var(--rap-shadow-lg)',\n                xl: 'var(--rap-shadow-xl)',\n                '2xl': 'var(--rap-shadow-2xl)',\n                inner: 'var(--rap-shadow-inner)',\n                none: 'none',\n            },\n            "+ m.group(1),
        rel,
    )
    changes[rel] = text

# GlobalStylesheet is an intentional React global-style layer, like Noobee's.
rel = "resources/scripts/assets/css/GlobalStylesheet.ts"
text = read(rel)
marker = "/* RAPELZ THEME GLOBAL CANVAS */"
if marker not in text:
    text = replace_once(
        text,
        r"letter-spacing:\s*0\.015em;",
        "letter-spacing: 0.015em;\n        /* RAPELZ THEME GLOBAL CANVAS */\n        background-color: var(--rap-bg);\n        color: var(--rap-text);\n        min-height: 100vh;",
        rel,
    )
changes[rel] = text

# Activate the modular stylesheet and remove the previous single-file CSS
# import if the earlier Rap-theme installer had already added it.
rel = "resources/scripts/components/App.tsx"
text = read(rel)
legacy_import = "import '@/assets/css/rapelz-theme.css';"
text = text.replace(legacy_import + "\n", "").replace(legacy_import, "")
new_import = "import '@/assets/css/rapelz-theme/entry.css';"
if new_import not in text:
    text = replace_once(
        text,
        r"import '@/assets/tailwind\.css';",
        "import '@/assets/tailwind.css';\n" + new_import,
        rel,
    )
changes[rel] = text

# Add narrowly scoped markers to the existing reusable components. The
# components retain Pterodactyl behavior, types, actions, and data flow.
patches = [
    (
        "resources/scripts/components/elements/ContentBox.tsx",
        "data-rapelz-component='content-panel'",
        r"<div css=(\{\[tw.*?!!borderColor.*?\]\})>",
        lambda m: "<div\n            data-rapelz-component='content-panel'\n            css=" + m.group(1) + "\n        >",
        re.S,
    ),
    (
        "resources/scripts/components/elements/TitledGreyBox.tsx",
        "data-rapelz-component='titled-panel'",
        r"<div css=\{tw.*?className=\{className\}>",
        lambda m: m.group(0).replace("<div ", "<div data-rapelz-component='titled-panel' ", 1),
        re.S,
    ),
    (
        "resources/scripts/components/elements/GreyRowBox.tsx",
        "'data-rapelz-component': 'row'",
        r"export default styled\.div<\{\s*\$hoverable\?: boolean\s*\}>",
        "export default styled.div.attrs({ 'data-rapelz-component': 'row' })<{ $hoverable?: boolean }>",
        0,
    ),
    (
        "resources/scripts/components/elements/Input.tsx",
        "'data-rapelz-component': 'input'",
        r"const Input = styled\.input<Props>",
        "const Input = styled.input.attrs({ 'data-rapelz-component': 'input' })<Props>",
        0,
    ),
    (
        "resources/scripts/components/elements/Input.tsx",
        "'data-rapelz-component': 'textarea'",
        r"const Textarea = styled\.textarea<Props>",
        "const Textarea = styled.textarea.attrs({ 'data-rapelz-component': 'textarea' })<Props>",
        0,
    ),
    (
        "resources/scripts/components/dashboard/ServerRow.tsx",
        "data-rapelz-component='server-row'",
        r"<StatusIndicatorBox as=\{Link\} to=\{.*?server\.id.*?\}\s+className=\{className\}\s+\$status=\{stats\?\.status\}>",
        lambda m: "<StatusIndicatorBox\n            as={Link}\n            to={" + chr(96) + "/server/" + chr(36) + "{server.id}" + chr(96) + "}\n            className={className}\n            data-rapelz-component='server-row'\n            $status={stats?.status}\n        >",
        re.S,
    ),
    (
        "resources/scripts/components/server/console/StatBlock.tsx",
        "rapelz-stat-card",
        r"classNames\(styles\.stat_block,\s*'bg-gray-600',\s*className\)",
        "classNames(styles.stat_block, 'bg-gray-600', 'rapelz-stat-card', className)",
        0,
    ),
    (
        "resources/scripts/components/server/console/ChartBlock.tsx",
        "rapelz-chart-card",
        r"classNames\(styles\.chart_container,\s*'group'\)",
        "classNames(styles.chart_container, 'group', 'rapelz-chart-card')",
        0,
    ),
    (
        "resources/scripts/components/server/files/FileObjectRow.tsx",
        "rapelz-file-row",
        r"className=\{styles\.file_row\}",
        lambda _m: "className={" + chr(96) + "{styles.file_row} rapelz-file-row" + chr(96) + "}",
        0,
    ),
]

for rel, marker, pattern, replacement, flags in patches:
    text = changes.get(rel, read(rel))
    if marker in text:
        changes[rel] = text
        continue
    text = replace_once(text, pattern, replacement, rel, flags=flags)
    changes[rel] = text

# AdminLTE remains a separate, existing CSS target.
rel = "resources/views/layouts/admin.blade.php"
text = read(rel)
if "Theme::css('css/rapelz-theme.css" not in text:
    if "Theme::css('css/pterodactyl.css?t={cache-version}')" in text:
        text = replace_once(
            text,
            r"(\{!! Theme::css\('css/pterodactyl\.css\?t=\{cache-version\}'\) !!\})",
            r"\1\n            {!! Theme::css('css/rapelz-theme.css?t={cache-version}') !!}",
            rel,
        )
    elif "Theme::css('css/pterodactyl.css')" in text:
        text = replace_once(
            text,
            r"(\{!! Theme::css\('css/pterodactyl\.css'\) !!\})",
            r"\1\n            {!! Theme::css('css/rapelz-theme.css') !!}",
            rel,
        )
    else:
        raise RuntimeError(f"Source anchor mismatch in {rel}; admin stylesheet registration not found. No source files written.")
changes[rel] = text

# All replacements are verified before the first write. Write only changed files.
for rel, text in changes.items():
    (root / rel).write_text(text, encoding="utf-8")
    print(f"Patched {rel}")
PY

DEST_THEME="$PANEL_DIR/resources/scripts/assets/css/rapelz-theme"
rm -rf "$DEST_THEME"
mkdir -p "$DEST_THEME"
cp -a "$SCRIPT_DIR/theme/." "$DEST_THEME/"

mkdir -p "$PANEL_DIR/public/themes/pterodactyl/css"
install -m 0644 "$SCRIPT_DIR/admin-theme.css" "$PANEL_DIR/public/themes/pterodactyl/css/rapelz-theme.css"
DEST_ADMIN="$PANEL_DIR/public/themes/pterodactyl/css/rapelz-admin"
rm -rf "$DEST_ADMIN"
mkdir -p "$DEST_ADMIN"
cp -a "$SCRIPT_DIR/admin/." "$DEST_ADMIN/"

echo
echo "Rapelz modular source integration complete."
echo "Backups: $BACKUP_DIR"
echo "Target: $PANEL_DIR"
echo
echo "NEXT (staging only):"
echo "  cd \"$PANEL_DIR\""
echo "  corepack yarn tsc"
echo "  corepack yarn build"
echo "  # Open the staging panel and smoke-test login, dashboard, server, console, files, and admin."
echo
echo "Do not run build:production in production: Pterodactyl's script cleans public/assets first."
