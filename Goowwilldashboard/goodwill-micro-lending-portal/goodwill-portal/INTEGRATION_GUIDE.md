# Goodwill Micro-Lending Portal: Integration & Operations Guide

This guide explains how the Goodwill Micro-Lending Portal operates as a front-end interface and how to connect it to real back-end services (like Supabase, Plaid, or custom core banking systems) to make it fully operational.

## 1. How the Portal Currently Works

Currently, this Next.js application serves as a **frontend demo** using mock data. 

- **App Router Architecture:** It utilizes the Next.js App Router (`app/` directory) with server components for data fetching and client components for interactive UI (framer-motion animations, Recharts, Shadcn UI).
- **Mock Data Layer:** Instead of hitting a real database, the app relies on JSON files located in `lib/mock-data/` (or hardcoded arrays in the new dashboard/loan components).
- **API Client:** In `lib/api-client.ts`, there are helper functions (like `getApplications()`) that simulate network latency and return mock data.

To make the app operational, you need to replace this mock layer with real external API calls or direct database connections.

---

## 2. Connecting to a Backend Database (e.g., Supabase)

If you are using Supabase for your database and authentication, follow these steps to integrate it:

### Step A: Install the Supabase Client
Install the required packages in your project root:
```bash
npm install @supabase/supabase-js @supabase/ssr
```

### Step B: Set Environment Variables
Create a `.env.local` file in the root of your project and add your Supabase credentials:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key # For admin actions only
```

### Step C: Create the Supabase Client Utility
Create a file at `lib/supabase.ts` to initialize the client:
```typescript
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### Step D: Wire up Data Fetching
Update the functions in `lib/api-client.ts` to fetch from Supabase instead of mock data.
**Example:** Fetching applications from a `loan_applications` table.
```typescript
// Old (Mock Data)
export async function getApplications() {
  return mockApplications;
}

// New (Supabase)
import { createClient } from '@/lib/supabase/server' // Assuming you set up server-side client

export async function getApplications() {
  const supabase = createClient();
  const { data: applications, error } = await supabase
    .from('loan_applications')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return applications;
}
```

---

## 3. Integrating Third-Party Services (KYC, Banking, etc.)

A lending portal typically requires integrations with external APIs for identity verification, banking data, and payments.

### Plaid (Bank Account Linking & Cash Flow Underwriting)
To underwrite loans accurately, you need merchant cash flow data.
1. Sign up for a [Plaid Developer Account](https://plaid.com/).
2. Install the Plaid SDK: `npm install plaid`.
3. Create an API route (`app/api/create_link_token/route.ts`) to generate a Plaid link token.
4. When a merchant applies on your external public-facing website, they connect their bank via Plaid Link. Plaid will return an `access_token` which you store in Supabase.
5. In this portal, you can then call Plaid's `/transactions/get` endpoint in `app/applications/[id]/page.tsx` to dynamically render the revenue charts.

### Stripe or TreasuryPrime (Disbursements & Repayments)
When an officer clicks "Approve" in the portal, capital needs to move.
1. Connect your portal's decision endpoint (`app/api/applications/[id]/decision/route.ts`) to your payment gateway.
2. If using Stripe Connect or a BaaS (Banking as a Service) like TreasuryPrime:
   ```typescript
   // Pseudo-code for approval action
   if (decision === 'approve') {
       await paymentGateway.disburse({
           merchantAccountId: application.merchant.bankAccountId,
           amount: application.requestedAmount
       });
       
       await supabase.from('loans').insert({...});
   }
   ```

### External Websites (Inbound Applications)
If you have a separate public website (e.g., built on Webflow, WordPress, or another Next.js app) where merchants apply for loans:
1. **Create an Intake API:** Build an API route in this portal (`app/api/applications/route.ts`) that accepts `POST` requests.
2. **Webhook or Direct POST:** Have your public website submit the application form data directly to this endpoint.
3. **Save and Alert:** The route should validate the payload, save it to Supabase, and optionally trigger a notification (e.g., Slack or email) to alert loan officers of a new pending application in the queue.

---

## 4. Architecture Checklist for Going Live

Before moving to production, ensure you have:
- [ ] **Authentication:** Replaced the mock login with Supabase Auth or NextAuth.js. Ensure `middleware.ts` correctly blocks unauthenticated users.
- [ ] **Database Setup:** Created your PostgreSQL tables (e.g., `merchants`, `applications`, `loans`, `transactions`) and established Row Level Security (RLS) policies.
- [ ] **API Security:** Ensured all API routes in `app/api/` verify the user's role (Loan Officer vs. Admin) before executing mutations (like approving a loan).
- [ ] **Webhooks:** In `/settings/api`, ensure you have a mechanism to listen to inbound webhooks (e.g., from Plaid for transaction updates, or Stripe for repayment failures).
