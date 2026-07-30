import { cn } from "@/lib/utils";
import type { RiskLevel } from "@/lib/types/application";

const CONFIG = {
  low: { label: "Low Risk", className: "bg-signal/15 text-signal border-signal/20" },
  medium: { label: "Medium Risk", className: "bg-amber/15 text-amber border-amber/20" },
  high: { label: "High Risk", className: "bg-danger/15 text-danger border-danger/20" },
} as const;

export function RiskBadge({ level }: { level: RiskLevel }) {
  const config = CONFIG[level];
  return (
    <span className={cn(
      "inline-flex items-center rounded-full border px-2 py-0.5 text-xs font-medium uppercase tracking-wider",
      config.className
    )}>
      {config.label}
    </span>
  );
}
