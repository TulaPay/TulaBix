# Goodwill Micro-Lending Portal

Architecture, layout shell, and the Merchant Underwriting View for Goodwill's
loan-officer dashboard. See `PROJECT_STRUCTURE.md` for the full file tree and
role-based access table.

## What's fully implemented here
- **App shell**: `app/dashboard/layout.tsx` + `components/layout/sidebar.tsx` +
  `components/layout/header.tsx` — collapsible role-aware nav, search, theme
  toggle, user menu.
- **Design tokens**: `app/globals.css` + `tailwind.config.ts` — the "Ledger"
  palette (ink-navy surfaces, signal-green for capital movement, amber for
  risk), tabular-mono numerals for every monetary value.
- **Merchant Underwriting View**: `app/applications/[id]/page.tsx` (server
  component, fetches via `lib/api-client.ts`) composed from:
  - `merchant-overview-card.tsx` — KYC, owner, linked account
  - `revenue-chart.tsx` — Recharts revenue/order-volume composed chart
  - `credit-health-gauge.tsx` — score gauge, risk badge, scoring factors
  - `decision-console.tsx` + `decision-confirm-dialog.tsx` — the approve/decline
    form with mandatory notes and a confirmation modal before any financial
    action is sent
  - `application-decision-panel.tsx` — thin client boundary wiring the console
    to the mutation + `router.refresh()` for optimistic-feeling updates
- **Mock data**: `lib/mock-data/applications.json` (4 full application
  records across every status) and `lib/mock-data/merchant-analytics.json`
  (standalone analytics payload shape, as would arrive from the core backend
  webhook).

## What's stubbed as structure only
Files listed in `PROJECT_STRUCTURE.md` for `/dashboard` metric cards and
charts, `/applications` queue table, `/loans`, `/wallet`, and
`/settings/api` are named and positioned but not written out in full — the
patterns established in the underwriting view (server component fetch +
thin client boundary for interactivity + Recharts for data viz) extend
directly to each.

## Running locally
```bash
npm install
npm run dev
```
The app runs entirely on `lib/mock-data/*.json` by default
(`NEXT_PUBLIC_USE_MOCKS` defaults to true). Point `CORE_BACKEND_API_URL` and
`CORE_BACKEND_API_KEY` at the real SME core backend and set
`NEXT_PUBLIC_USE_MOCKS=false` to go live.
