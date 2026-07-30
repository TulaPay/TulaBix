"use client";

import { motion } from "framer-motion";
import { BalanceCards } from "@/components/wallet/balance-cards";
import { TransactionHistoryTable } from "@/components/wallet/transaction-history-table";
import { Button } from "@/components/ui/button";
import { ArrowDownToLine, ArrowUpFromLine } from "lucide-react";

export default function WalletPage() {
  return (
    <div className="space-y-6 pb-12">
      <div className="animate-fade-in flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="font-display text-3xl font-bold tracking-tight">Liquidity & Wallet</h1>
          <p className="text-muted-foreground mt-2">
            Manage fund liquidity and monitor ledger transactions.
          </p>
        </div>
        <div className="flex gap-3">
          <Button variant="outline" className="gap-2 bg-surface hover:bg-surface-muted">
            <ArrowDownToLine className="h-4 w-4" />
            Withdraw
          </Button>
          <Button className="gap-2 bg-signal text-signal-foreground hover:bg-signal/90">
            <ArrowUpFromLine className="h-4 w-4" />
            Inject Capital
          </Button>
        </div>
      </div>

      <div className="animate-slide-up-fade" style={{ animationDelay: "100ms", animationFillMode: "both" }}>
        <BalanceCards />
      </div>

      <div className="animate-slide-up-fade" style={{ animationDelay: "200ms", animationFillMode: "both" }}>
        <TransactionHistoryTable />
      </div>
    </div>
  );
}
