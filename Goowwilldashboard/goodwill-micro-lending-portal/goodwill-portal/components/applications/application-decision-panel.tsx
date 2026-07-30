"use client";

import { useRouter } from "next/navigation";
import { DecisionConsole } from "@/components/applications/decision-console";
import { submitApplicationDecision } from "@/lib/api-client";
import type { LoanApplication } from "@/lib/types/application";

export function ApplicationDecisionPanel({ application }: { application: LoanApplication }) {
  const router = useRouter();

  // Only actionable while still pending / under review.
  if (application.status !== "pending" && application.status !== "under_review") {
    return null;
  }

  async function handleDecision(payload: {
    action: "approve" | "decline";
    amount: number;
    interestRate: number;
    tenureMonths: number;
    dailyDeductionPercent: number;
    notes: string;
  }) {
    await submitApplicationDecision(application.id, payload);
    // Optimistic navigation refresh — server component re-fetches the now-updated status.
    router.refresh();
  }

  return <DecisionConsole application={application} onDecision={handleDecision} />;
}
