# Rapelz Modular Theme Architecture

This directory is the modular React styling layer for Pterodactyl 1.15.1. It preserves Rapelz's navy / electric-blue / green design language and uses Noobee-inspired engineering patterns: build-time design tokens, Pterodactyl's existing reusable React components, scoped component markers, and page-specific rules.

## CSS layers

- `tokens.css`: one source of truth for runtime CSS variables and shared dimensions.
- `base.css`: application canvas support, focus accessibility, scrollbar and mobile safeguards only.
- `components/`: styles for explicit Rapelz component markers; no blanket selectors for all Tailwind classes.
- `pages/`: targeted dashboard, console and file-row details.
- `entry.css`: deterministic entry point imported after Pterodactyl's Tailwind stylesheet.
- `manifest.json`: documents the entry and stylesheet list.

## Design system strategy

Most visual colors are now compiled as native Tailwind utility values by the source overlay patch to `tailwind.config.js`. Existing React components such as `ContentBox`, `Input`, `GreyRowBox`, `TitledGreyBox`, `ServerRow`, console metrics, and file rows keep their existing component boundaries and behavior while using the Rapelz design tokens. This is closer to component-level styling than globally overriding every class selector.

The CSS modules already used by Pterodactyl for the console and file manager stay in place. Theme CSS is limited to small global foundations and explicit Rapelz markers.

## Boundaries

- No Noobee branding, palette, or product features are copied.
- No Backup Manager is integrated as a Pterodactyl feature.
- No route, API contract, authentication, permission, server action, or websocket behavior is intentionally changed.
- No addon is required.
- AdminLTE's Blade-based admin interface remains a separate CSS target.
- The source overlay is version-anchored to the expected Pterodactyl 1.15.1 file structure. If anchors differ, it stops and asks for review.
- Build and smoke-test in staging before production deployment.
