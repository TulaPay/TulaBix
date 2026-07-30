"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion } from "framer-motion";
import { Key, Shield, Sliders } from "lucide-react";

const navigation = [
  { name: "API & Webhooks", href: "/settings/api", icon: Key },
  { name: "Roles & Permissions", href: "/settings/roles", icon: Shield },
  { name: "Risk Criteria", href: "/settings/risk-criteria", icon: Sliders },
];

export default function SettingsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();

  return (
    <div className="space-y-6 pb-12">
      <div className="animate-fade-in">
        <h1 className="font-display text-3xl font-bold tracking-tight">Settings</h1>
        <p className="text-muted-foreground mt-2">
          Manage system configurations, API integrations, and access control.
        </p>
      </div>

      <div className="flex flex-col md:flex-row gap-8 animate-slide-up-fade" style={{ animationDelay: "100ms", animationFillMode: "both" }}>
        <aside className="md:w-64 flex-shrink-0">
          <nav className="flex md:flex-col gap-2 overflow-x-auto pb-4 md:pb-0">
            {navigation.map((item) => {
              const isActive = pathname === item.href;
              const Icon = item.icon;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`flex items-center gap-3 px-3 py-2 rounded-lg transition-colors whitespace-nowrap relative ${
                    isActive
                      ? "text-foreground font-medium"
                      : "text-muted-foreground hover:text-foreground hover:bg-surface-muted/50"
                  }`}
                >
                  {isActive && (
                    <motion.div
                      layoutId="active-nav"
                      className="absolute inset-0 bg-surface rounded-lg border border-border/50 shadow-sm -z-10"
                      transition={{ type: "spring", stiffness: 300, damping: 30 }}
                    />
                  )}
                  <Icon className={`h-4 w-4 ${isActive ? "text-signal" : ""}`} />
                  {item.name}
                </Link>
              );
            })}
          </nav>
        </aside>

        <main className="flex-1">
          {children}
        </main>
      </div>
    </div>
  );
}
