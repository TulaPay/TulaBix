export type UserRole = "loan_officer" | "fund_manager" | "super_admin";

export type ApplicationStatus =
  | "pending"
  | "under_review"
  | "approved"
  | "declined";

export type RiskLevel = "low" | "medium" | "high";

export type KycStatus = "verified" | "pending" | "flagged";

export interface RevenuePoint {
  date: string; // ISO date
  revenue: number;
  orders: number;
}

export interface AnalyticsSummary {
  averageOrderValue: number;
  monthlyOrderVolume: number;
  revenueConsistencyScore: number; // 0-100, higher = more predictable
  last90DaysRevenue: RevenuePoint[];
}

export interface CreditAssessment {
  creditHealthScore: number; // 0-850, underwriting-style score
  maxRecommendedLoan: number;
  riskLevel: RiskLevel;
  scoringFactors: { label: string; weight: number; impact: "positive" | "negative" }[];
}

export interface MerchantProfile {
  id: string;
  businessName: string;
  ownerName: string;
  ownerEmail: string;
  ownerPhone: string;
  kycStatus: KycStatus;
  linkedAccount: {
    provider: string; // e.g. "Mobile Money", "Bank Transfer"
    accountLast4: string;
  };
  memberSince: string; // ISO date
  revenueTier: "starter" | "growth" | "scale";
}

export interface LoanApplication {
  id: string;
  status: ApplicationStatus;
  requestedAmount: number;
  requestedTenureMonths: number;
  submittedAt: string; // ISO date
  merchant: MerchantProfile;
  analytics: AnalyticsSummary;
  credit: CreditAssessment;
  decision?: {
    approvedAmount: number;
    interestRate: number;
    tenureMonths: number;
    dailyDeductionPercent: number;
    decidedBy: string;
    decidedAt: string;
    notes: string;
  };
}
