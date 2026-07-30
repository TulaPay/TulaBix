import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

// In a real app this comes from the authenticated session (e.g. next-auth / Clerk).
const CURRENT_USER = {
  name: "Amara Okafor",
  role: "super_admin" as const,
};

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex h-screen overflow-hidden bg-background">
      <Sidebar role={CURRENT_USER.role} />
      <div className="flex flex-1 flex-col overflow-hidden">
        <Header userName={CURRENT_USER.name} userRole={CURRENT_USER.role} />
        <main className="flex-1 overflow-y-auto">
          <div className="mx-auto max-w-[1400px] px-4 py-6 md:px-8 md:py-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
