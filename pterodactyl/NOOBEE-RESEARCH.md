# Noobee v1.1.1 — implementation notes for Rap-theme

This document records what was learned from the supplied Noobee v1.1.1 source archive and how those ideas are applied without replacing Rapelz's visual identity.

## What Noobee changes beyond colors

The archive is a Pterodactyl React-client source overlay, not just a stylesheet. Its changes are spread across several layers:

- **Global styling** — `resources/scripts/assets/css/GlobalStylesheet.ts` uses styled-components and Tailwind's `tw` helper for page background, typography, focus resets, number inputs, and scrollbar behavior.
- **Reusable UI primitives** — `components/elements/Input.tsx`, `ContentBox.tsx`, `TitledGreyBox.tsx`, and `GreyRowBox.tsx` centralize form and panel styling instead of styling every screen independently.
- **Route composition** — `routers/DashboardRouter.tsx`, `ServerRouter.tsx`, and `RouterElements.tsx` build navigation from route definitions, enforce permissions, handle suspense/loading, and filter egg/nest-specific links.
- **Dashboard server rows** — `components/dashboard/ServerRow.tsx` combines server status, resource metrics, and alarm thresholds in one reusable row. This is component behavior/layout, not something CSS alone can fully recreate.
- **Server console metrics** — `StatBlock.tsx`, `ChartBlock.tsx`, and `console/style.module.css` provide reusable metric cards, charts, and terminal layout.
- **File manager rows** — `FileObjectRow.tsx` and `files/style.module.css` separate file-row layout from the file data/actions.
- **API data mapping** — `api/server/getServer.ts` normalizes API fields into a typed server model. `app/Transformers/Api/Client/ServerTransformer.php` supplies status, node-maintenance, resource limits, and feature limits.

## What was implemented in Rap-theme

Rap-theme remains Rapelz navy/blue/green. The React stylesheet now applies the reusable design principles to the existing Pterodactyl UI: consistent global canvas and scrollbars, clearer panel hierarchy, compact table headers, consistent focus states, and responsive safeguards for long tables and terminal/code panes.

## Important boundaries

- No Noobee branding, colors, logos, or visual theme are copied into Rapelz.
- No Backup Manager or other feature is added.
- This CSS layer does not change routes, API contracts, permissions, authentication, server actions, or websocket behavior.
- CSS cannot add Noobee's metric calculations, alarm thresholds, data fields, or component structure. Those require deliberate TypeScript/PHP changes against the exact installed Pterodactyl version.
- Noobee's PHP transformer and React source files must not be blindly copied over a production panel. Treat them as implementation references and port behavior only when there is a specific product requirement and a version-compatible test.
- The theme installer still needs a production staging build after pulling repository changes; changing GitHub does not deploy to the live panel automatically.
