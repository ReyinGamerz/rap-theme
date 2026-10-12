# Rapelz Modular Theme Architecture

This directory is the modular CSS foundation for the React-facing Pterodactyl UI. It preserves Rapelz's navy / electric-blue / green design language and applies Noobee-inspired engineering principles: design tokens, small responsibilities, reusable styles, and page-scoped rules.

## CSS layers

- `tokens.css`: one source of truth for colors, spacing, radii, borders, and focus rings.
- `base.css`: global canvas, typography defaults, focus accessibility, scrollbar, and media safety only.
- `components/`: reusable presentation for panels, controls, and data display.
- `pages/`: narrowly scoped dashboard, console, and file-manager details.
- `manifest.json`: documented deterministic load order.

## Important integration status

This directory is a refactoring foundation, not yet a drop-in replacement for `pterodactyl/react-theme.css`. Pterodactyl 1.15.1 source must explicitly import the generated entry from `resources/scripts/components/App.tsx` after its existing Tailwind import, and the full React source build must pass in staging. Do not deploy this branch to production until component DOM structures and selectors have been reviewed against the exact panel source.

The existing `react-theme.css` and `admin-theme.css` are intentionally kept unchanged in this branch as a rollback/reference. AdminLTE's Blade-based admin UI remains a separate styling target from the React client.

## Design rules

1. Keep the Rapelz palette and interaction language; do not copy Noobee branding or palette.
2. Prefer stable Pterodactyl component classes / scoped markers over broad class substring selectors.
3. Never change routes, permissions, authentication, API payloads, websocket behavior, or server actions from theme code.
4. Do not couple styles to third-party addons.
5. Changes to React components are separate, version-aware patches; never copy a Noobee component blindly into Pterodactyl 1.15.1.
