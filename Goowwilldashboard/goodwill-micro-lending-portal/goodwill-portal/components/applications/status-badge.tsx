import { cn } from "@/lib/utils";
import type { ApplicationStatus, RiskLevel } from "@/lib/types/application";

const STATUS_CONFIG: Record<ApplicationStatus, { label: string; className: string }> = {
  pending: {
    label: "Pending",
    className: "bg-surface-muted text-muted-foreground",
  },
  under_review: {
    label: "Under review",
    className: "bg-amber/15 text-amber",
  },
  approved: {
    label: "Approved",
    className: "bg-signal/15 text-signal",
  },
  declined: {
    label: "Declined",
    className: "bg-danger/15 text-danger",
  },
};

export function StatusBadge({ status }: { status: ApplicationStatus }) {
  const config = STATUS_CONFIG[status];
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
        config.className
      )}
    >
      {config.label}
    </span>
  );
}

const RISK_CONFIG: Record<RiskLevel, { label: string; className: string }> = {
  low: { label: "Low risk", className: "bg-signal/15 text-signal" },
  medium: { label: "Medium risk", className: "bg-amber/15 text-amber" },
  high: { label: "High risk", className: "bg-danger/15 text-danger" },
};

export function RiskBadge({ level }: { level: RiskLevel }) {
  const config = RISK_CONFIG[level];
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium",
        config.className
      )}
    >
      <span className="h-1.5 w-1.5 rounded-full bg-current" />
      {config.label}
    </span>
  );
}
