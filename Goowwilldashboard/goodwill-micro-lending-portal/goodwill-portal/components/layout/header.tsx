"use client";

import { Search, Bell, Moon, Sun, Menu } from "lucide-react";
import { useTheme } from "next-themes";
import { Input } from "@/components/ui/input";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface HeaderProps {
  userName: string;
  userRole: string;
  onOpenMobileNav?: () => void;
}

export function Header({ userName, userRole, onOpenMobileNav }: HeaderProps) {
  const { theme, setTheme } = useTheme();

  return (
    <header className="flex h-16 items-center gap-4 border-b border-border bg-surface px-4 md:px-6">
      <button
        className="md:hidden text-muted-foreground"
        onClick={onOpenMobileNav}
        aria-label="Open navigation"
      >
        <Menu className="h-5 w-5" />
      </button>

      <div className="relative hidden max-w-sm flex-1 md:block">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          placeholder="Search merchants, applications, loan IDs…"
          className="pl-9"
        />
      </div>

      <div className="ml-auto flex items-center gap-2">
        <button
          onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
          aria-label="Toggle theme"
          className="rounded-md p-2 text-muted-foreground hover:bg-surface-muted hover:text-foreground"
        >
          <Sun className="h-[18px] w-[18px] dark:hidden" />
          <Moon className="hidden h-[18px] w-[18px] dark:block" />
        </button>

        <button
          aria-label="Notifications"
          className="relative rounded-md p-2 text-muted-foreground hover:bg-surface-muted hover:text-foreground"
        >
          <Bell className="h-[18px] w-[18px]" />
          <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 rounded-full bg-amber" />
        </button>

        <DropdownMenu>
          <DropdownMenuTrigger className="flex items-center gap-2 rounded-md px-2 py-1.5 hover:bg-surface-muted">
            <div className="flex h-8 w-8 items-center justify-center rounded-full bg-signal/15 font-display text-sm font-semibold text-signal">
              {userName.charAt(0)}
            </div>
            <div className="hidden text-left md:block">
              <p className="text-sm font-medium leading-none">{userName}</p>
              <p className="mt-0.5 text-xs capitalize text-muted-foreground">
                {userRole.replace("_", " ")}
              </p>
            </div>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuItem>Profile</DropdownMenuItem>
            <DropdownMenuItem>Switch organization</DropdownMenuItem>
            <DropdownMenuItem>Sign out</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
