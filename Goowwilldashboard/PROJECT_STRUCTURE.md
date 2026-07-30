# Goodwill Micro-Lending Portal — Project Structure

Design system: **"Ledger"** — a fintech-trust palette built around deep ink-navy
surfaces, a muted signal-green for capital/growth data, and a warm amber for
risk/attention states. Display type is a geometric grotesk (headline weight
only), body/data type is a neutral grotesk, and all monetary figures render in
a tabular-lining mono so columns of numbers actually line up — this is the one
non-negotiable for a lending product.

```
goodwill-portal/
├── app/
│   ├── layout.tsx                       # Root layout: fonts, theme provider, toaster
│   ├── globals.css                      # Tailwind base + CSS variable tokens (light/dark)
│   ├── page.tsx                         # Redirects "/" -> "/dashboard"
│   │
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── layout.tsx                   # Centered, unauthenticated shell
│   │
│   ├── dashboard/
│   │   ├── layout.tsx                   # Authenticated app shell (Sidebar + Header + Toaster)
│   │   ├── page.tsx                     # Executive Dashboard (/dashboard)
│   │   └── loading.tsx                  # Skeleton for metric cards + charts
│   │
│   ├── applications/
│   │   ├── layout.tsx                   # Inherits dashboard shell via route group
│   │   ├── page.tsx                     # Loan Applications Queue (/applications)
│   │   ├── loading.tsx
│   │   └── [id]/
│   │       ├── page.tsx                 # Merchant Profile & Underwriting View
│   │       ├── loading.tsx
│   │       └── not-found.tsx
│   │
│   ├── loans/
│   │   ├── page.tsx                     # Active Loans & Repayment Ledger (/loans)
│   │   └── [id]/page.tsx                # Single loan detail + manual override
│   │
│   ├── wallet/
│   │   └── page.tsx                     # Wallet & Liquidity Management (/wallet)
│   │
│   ├── settings/
│   │   ├── layout.tsx                   # Settings sub-nav (API, Roles, Risk Criteria, Rates)
│   │   ├── page.tsx                     # Redirect -> /settings/api
│   │   ├── api/page.tsx                 # API Key & Webhook Configuration
│   │   ├── risk-criteria/page.tsx       # Super Admin: scoring weight config
│   │   └── roles/page.tsx               # Super Admin: team & role management
│   │
│   └── api/
│       ├── applications/route.ts        # GET list, POST decision (approve/decline)
│       ├── applications/[id]/route.ts   # GET single application + analytics payload
│       ├── loans/route.ts               # GET active loans, POST manual repayment
│       ├── wallet/route.ts              # GET ledger + balances
│       └── webhooks/core-backend/route.ts  # Inbound sync from SME core app
│
├── components/
│   ├── layout/
│   │   ├── sidebar.tsx                  # Collapsible primary nav, role-aware
│   │   ├── header.tsx                   # Search, org switcher, theme toggle, user menu
│   │   ├── mobile-nav.tsx               # Sheet-based nav for < md breakpoints
│   │   └── page-header.tsx              # Shared page title + breadcrumb + actions slot
│   │
│   ├── dashboard/
│   │   ├── metric-card.tsx              # KPI card (value, delta, sparkline slot)
│   │   ├── disbursement-chart.tsx       # Recharts line: disbursement vs repayment
│   │   ├── risk-distribution-chart.tsx  # Recharts pie: Low/Medium/High risk
│   │   └── activity-feed.tsx            # Live activity list w/ relative timestamps
│   │
│   ├── applications/
│   │   ├── applications-table.tsx       # TanStack Table + filter bar
│   │   ├── applications-filters.tsx     # Status/date/risk/revenue-tier filters
│   │   ├── status-badge.tsx             # Pending/Under Review/Approved/Declined
│   │   ├── risk-badge.tsx               # Low/Medium/High risk pill
│   │   ├── merchant-overview-card.tsx   # KYC, owner, linked accounts
│   │   ├── revenue-chart.tsx            # Daily/monthly revenue + AOV + order volume
│   │   ├── credit-health-gauge.tsx      # Score gauge + max recommended offer
│   │   ├── decision-console.tsx         # Amount/rate/tenure/schedule form
│   │   └── decision-confirm-dialog.tsx  # Confirmation modal before approve/decline
│   │
│   ├── loans/
│   │   ├── loans-table.tsx
│   │   ├── repayment-log.tsx
│   │   └── manual-repayment-dialog.tsx
│   │
│   ├── wallet/
│   │   ├── balance-cards.tsx
│   │   └── transaction-history-table.tsx
│   │
│   └── ui/                              # shadcn/ui primitives (button, dialog, table, etc.)
│       ├── button.tsx
│       ├── card.tsx
│       ├── dialog.tsx
│       ├── table.tsx
│       ├── badge.tsx
│       ├── skeleton.tsx
│       ├── toast.tsx / toaster.tsx
│       ├── select.tsx
│       ├── tabs.tsx
│       ├── input.tsx
│       └── dropdown-menu.tsx
│
├── lib/
│   ├── types/
│   │   ├── application.ts               # LoanApplication, KycStatus, RiskLevel
│   │   ├── loan.ts                      # ActiveLoan, RepaymentEntry
│   │   ├── merchant.ts                  # MerchantProfile, AnalyticsSummary
│   │   └── wallet.ts                    # WalletBalance, LedgerEntry
│   ├── mock-data/
│   │   ├── applications.json
│   │   ├── merchant-analytics.json
│   │   └── loans.json
│   ├── api-client.ts                    # fetch wrapper, error normalization
│   ├── risk-engine.ts                   # client-side helpers for score bands/colors
│   ├── format.ts                        # currency/date/percent formatters
│   └── utils.ts                         # cn() and misc helpers
│
├── hooks/
│   ├── use-applications.ts              # SWR/React Query hook w/ optimistic decision mutation
│   ├── use-toast.ts
│   └── use-media-query.ts
│
├── middleware.ts                        # Route protection by role (officer/fund_manager/admin)
├── tailwind.config.ts                   # Design tokens (see globals.css variables)
├── next.config.mjs
├── package.json
└── tsconfig.json
```

### Role-based access (enforced in `middleware.ts` + server components)
| Route                  | Loan Officer | Fund Manager | Super Admin |
|-------------------------|:---:|:---:|:---:|
| `/dashboard`            | ✅ | ✅ | ✅ |
| `/applications*`        | ✅ | 👁 read-only | ✅ |
| `/loans`                | 👁 read-only | ✅ | ✅ |
| `/wallet`               | ❌ | ✅ | ✅ |
| `/settings/api`         | ❌ | ❌ | ✅ |
