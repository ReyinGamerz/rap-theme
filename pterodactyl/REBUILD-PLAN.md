# Rap-theme rebuild: Noobee-inspired architecture, Rapelz design

## Goal

Rebuild Rap-theme so its implementation is modular and maintainable while retaining the existing Rapelz palette and visual direction. No Noobee branding or palette is copied. No addon integration is required or assumed. Do not introduce Backup Manager as a Pterodactyl feature.

## Scope and phases

### Phase 1 — design system foundation
- Centralize palette, border, radius, spacing, and focus tokens.
- Split general CSS into base, shared component, and page-specific layers.
- Keep legacy stylesheet files intact for rollback and comparison.

### Phase 2 — map UI components
- Inspect Pterodactyl 1.15.1 source for its actual React component tree and stable DOM contracts.
- Identify existing elements that should receive Rapelz styles without behavior changes.
- Add Rapelz reusable components only where a real design/maintenance benefit exists. Do not duplicate Pterodactyl behavior gratuitously.

### Phase 3 — controlled component refactor
- Port one UI area at a time: shared primitives, dashboard rows, server navigation, console metric layout, and file manager rows.
- Preserve API types, route permission logic, console/websocket behavior, and existing user actions.
- No copied Noobee file may overwrite upstream Pterodactyl source wholesale; ports are deliberate, minimal, and version-checked.

### Phase 4 — validation
- Verify CSS build, TypeScript, and webpack on the exact Pterodactyl 1.15.1 source in staging.
- Test guest/login, dashboard, server navigation, console, file manager, mobile layout, and admin Blade UI.
- Confirm no third-party addon is required.
- Keep production unchanged until the staging build and smoke tests pass.

## Current branch status

The modular CSS foundation is being introduced here. It is not yet integrated into Pterodactyl's `App.tsx`, and it has not been verified through a complete 1.15.1 source build in this repository context. The current source code for React UI components is not part of this theme-only repository. Full component refactoring must therefore be carried out against the staging panel source, then recorded as a reproducible patch/integration step.
