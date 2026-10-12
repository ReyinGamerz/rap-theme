# Manual UI Smoke Test — Rapelz Backup Manager

This is a static demo. Records and summary cards are mock data; the Settings Save/Test controls are preview-only and do not call the backend.

## Open the prototype

Open `index.html` in a modern browser, or serve this directory locally with any static file server. Keep it off public hosting until the review is complete.

## Checklist

- [ ] Overview loads without a blank screen.
- [ ] Open Backups; table shows demo records.
- [ ] Choose Node 1 and apply filter; every visible record belongs to `node-001`.
- [ ] Change type/status/date/search and confirm results update.
- [ ] Reset filters and check pagination + sort controls.
- [ ] Open Restore Center, Node & Migration, Schedules, Reports, and Settings; section navigation works.
- [ ] In Settings, invalid/non-Discord URL is rejected.
- [ ] Enter a fake placeholder URL matching the format only if testing the UI; Save should clear the password field and display masked/configured status.
- [ ] Test button shows a preview-only message and does not send a real webhook.
- [ ] On mobile width, open/close the sidebar and check the backup table scrolls horizontally.
- [ ] Keyboard: Ctrl/Cmd+K focuses global search.

## What this does not verify

It does not verify a real Discord webhook, API authentication, Pterodactyl Admin integration, live backup data, restore, migration, or production server health. Those require backend staging tests.
