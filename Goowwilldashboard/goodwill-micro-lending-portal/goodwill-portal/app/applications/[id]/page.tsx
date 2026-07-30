import { notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { StatusBadge } from "@/components/applications/status-badge";
import { MerchantOverviewCard } from "@/components/applications/merchant-overview-card";
import { RevenueChart } from "@/components/applications/revenue-chart";
import { CreditHealthGauge } from "@/components/applications/credit-health-gauge";
import { ApplicationDecisionPanel } from "@/components/applications/application-decision-panel";
import { getApplicationById } from "@/lib/api-client";

export default async function MerchantApplicationPage({
  params,
}: {
  params: { id: string };
}) {
  const application = await getApplicationById(params.id);
  if (!application) notFound();

  return (
    <div className="space-y-6 pb-12">
      <div>
        <Link
          href="/applications"
          className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to applications
        </Link>

        <div className="flex flex-wrap items-center justify-between gap-3">
          <div>
            <h1 className="font-display text-2xl font-semibold tracking-tight">
              {application.merchant.businessName}
            </h1>
            <p className="mt-1 text-sm text-muted-foreground">
              Application {application.id} · submitted{" "}
              {new Date(application.submittedAt).toLocaleDateString("en-US", {
                month: "short",
                day: "numeric",
                year: "numeric",
              })}
            </p>
          </div>
          <StatusBadge status={application.status} />
        </div>
      </div>

      <MerchantOverviewCard merchant={application.merchant} />

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <RevenueChart data={application.analytics.last90DaysRevenue} />

          <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-4">
            <StatTile
              label="Avg. order value"
              value={application.analytics.averageOrderValue}
              format="currency"
            />
            <StatTile
              label="Monthly order volume"
              value={application.analytics.monthlyOrderVolume}
              format="number"
            />
            <StatTile
              label="Revenue consistency"
              value={application.analytics.revenueConsistencyScore}
              format="percent"
            />
            <StatTile
              label="Requested amount"
              value={application.requestedAmount}
              format="currency"
            />
          </div>
        </div>

        <div>
          <CreditHealthGauge credit={application.credit} />
        </div>
      </div>

      {/* Client boundary: holds the interactive decision form + optimistic mutation */}
      <ApplicationDecisionPanel application={application} />
    </div>
  );
}

function StatTile({
  label,
  value,
  format,
}: {
  label: string;
  value: number;
  format: "currency" | "number" | "percent";
}) {
  const display =
    format === "currency"
      ? value.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 })
      : format === "percent"
      ? `${value}%`
      : value.toLocaleString("en-US");

  return (
    <div className="rounded-lg border border-border bg-surface p-4">
      <p className="text-xs text-muted-foreground">{label}</p>
      <p className="mt-1 font-mono-tabular text-lg font-semibold">{display}</p>
    </div>
  );
}
