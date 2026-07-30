import { getApplications } from "@/lib/api-client";
import { ApplicationsTable } from "@/components/applications/applications-table";
import { ApplicationsFilters } from "@/components/applications/applications-filters";

export default async function ApplicationsPage() {
  const applications = await getApplications();

  return (
    <div className="space-y-6 pb-12">
      <div className="animate-fade-in">
        <h1 className="font-display text-3xl font-bold tracking-tight">Loan Applications</h1>
        <p className="text-muted-foreground mt-2">
          Review and process incoming merchant loan requests.
        </p>
      </div>

      <div className="animate-slide-up-fade" style={{ animationDelay: "100ms", animationFillMode: "both" }}>
        <ApplicationsFilters />
        <ApplicationsTable applications={applications} />
      </div>
    </div>
  );
}
