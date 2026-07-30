"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";
import {
  LayoutDashboard,
  FileClock,
  Landmark,
  Wallet,
  Settings2,
  ChevronsLeft,
  ChevronsRight,
} from "lucide-react";
import { cn } from "@/lib/utils";
import type { UserRole } from "@/lib/types/application";

interface NavItem {
  label: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  roles: UserRole[];
  badge?: number;
}

const NAV_ITEMS: NavItem[] = [
  {
    label: "Dashboard",
    href: "/dashboard",
    icon: LayoutDashboard,
    roles: ["loan_officer", "fund_manager", "super_admin"],
  },
  {
    label: "Applications",
    href: "/applications",
    icon: FileClock,
    roles: ["loan_officer", "fund_manager", "super_admin"],
    badge: 12,
  },
  {
    label: "Active Loans",
    href: "/loans",
    icon: Landmark,
    roles: ["loan_officer", "fund_manager", "super_admin"],
  },
  {
    label: "Wallet",
    href: "/wallet",
    icon: Wallet,
    roles: ["fund_manager", "super_admin"],
  },
  {
    label: "Settings",
    href: "/settings/api",
    icon: Settings2,
    roles: ["super_admin"],
  },
];

export function Sidebar({ role = "super_admin" }: { role?: UserRole }) {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);
  const visibleItems = NAV_ITEMS.filter((item) => item.roles.includes(role));

  return (
    <aside
      className={cn(
        "hidden md:flex h-screen flex-col border-r border-border bg-surface transition-[width] duration-200",
        collapsed ? "w-[72px]" : "w-64"
      )}
    >
      <div className="flex h-16 items-center gap-2 border-b border-border px-4">
        <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-md bg-primary text-primary-foreground font-display text-sm font-semibold">
          G
        </div>
        {!collapsed && (
          <span className="font-display text-[15px] font-semibold tracking-tight">
            Goodwill
          </span>
        )}
      </div>

      <nav className="flex-1 space-y-1 overflow-y-auto p-3">
        {visibleItems.map((item) => {
          const isActive = pathname?.startsWith(item.href);
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "group flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors",
                isActive
                  ? "bg-surface-muted text-foreground"
                  : "text-muted-foreground hover:bg-surface-muted hover:text-foreground"
              )}
            >
              <Icon
                className={cn(
                  "h-[18px] w-[18px] shrink-0",
                  isActive && "text-signal"
                )}
              />
              {!collapsed && <span className="flex-1 truncate">{item.label}</span>}
              {!collapsed && item.badge && (
                <span className="rounded-full bg-amber/15 px-1.5 py-0.5 text-xs font-mono-tabular font-medium text-amber">
                  {item.badge}
                </span>
              )}
            </Link>
          );
        })}
      </nav>

      <div className="border-t border-border p-3">
        <button
          onClick={() => setCollapsed((c) => !c)}
          aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
          className="flex w-full items-center justify-center gap-2 rounded-md py-2 text-muted-foreground hover:bg-surface-muted hover:text-foreground"
        >
          {collapsed ? (
            <ChevronsRight className="h-4 w-4" />
          ) : (
            <>
              <ChevronsLeft className="h-4 w-4" />
              <span className="text-xs font-medium">Collapse</span>
            </>
          )}
        </button>
      </div>
    </aside>
  );
}
