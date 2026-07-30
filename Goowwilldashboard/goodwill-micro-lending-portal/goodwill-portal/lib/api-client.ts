import type { LoanApplication } from "@/lib/types/application";
import applicationsMock from "@/lib/mock-data/applications.json";

const USE_MOCKS = process.env.NEXT_PUBLIC_USE_MOCKS !== "false";
const CORE_API_BASE = process.env.CORE_BACKEND_API_URL;

export async function getApplicationById(id: string): Promise<LoanApplication | null> {
  if (USE_MOCKS) {
    const match = (applicationsMock as LoanApplication[]).find((a) => a.id === id);
    return match ?? null;
  }

  const res = await fetch(`${CORE_API_BASE}/applications/${id}`, {
    headers: { Authorization: `Bearer ${process.env.CORE_BACKEND_API_KEY}` },
    next: { revalidate: 30 },
  });
  if (res.status === 404) return null;
  if (!res.ok) throw new Error(`Failed to load application ${id}: ${res.status}`);
  return res.json();
}

export async function getApplications(): Promise<LoanApplication[]> {
  if (USE_MOCKS) return applicationsMock as LoanApplication[];

  const res = await fetch(`${CORE_API_BASE}/applications`, {
    headers: { Authorization: `Bearer ${process.env.CORE_BACKEND_API_KEY}` },
    next: { revalidate: 30 },
  });
  if (!res.ok) throw new Error(`Failed to load applications: ${res.status}`);
  return res.json();
}

export interface DecisionPayload {
  action: "approve" | "decline";
  amount: number;
  interestRate: number;
  tenureMonths: number;
  dailyDeductionPercent: number;
  notes: string;
}

export async function submitApplicationDecision(
  applicationId: string,
  payload: DecisionPayload
): Promise<{ ok: true }> {
  if (USE_MOCKS) {
    // Simulate network latency + webhook round-trip in local/demo mode.
    await new Promise((resolve) => setTimeout(resolve, 600));
    return { ok: true };
  }

  const res = await fetch(`/api/applications/${applicationId}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`Decision submission failed: ${res.status}`);
  return res.json();
}
