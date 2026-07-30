"use client";

import { motion } from "framer-motion";
import { LoansTable } from "@/components/loans/loans-table";
import { ManualRepaymentDialog } from "@/components/loans/manual-repayment-dialog";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function LoansPage() {
  return (
    <div className="space-y-6 pb-12">
      <div className="animate-fade-in flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="font-display text-3xl font-bold tracking-tight">Active Loans Ledger</h1>
          <p className="text-muted-foreground mt-2">
            Monitor outstanding principal and record repayments.
          </p>
        </div>
        <ManualRepaymentDialog />
      </div>

      <div className="grid gap-6 md:grid-cols-3 animate-slide-up-fade" style={{ animationDelay: "100ms", animationFillMode: "both" }}>
        <Card className="glass md:col-span-1">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Total Active Principal</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="font-mono-tabular text-3xl font-bold tracking-tight">$100,000</div>
          </CardContent>
        </Card>
        <Card className="glass md:col-span-1">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Total Outstanding</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="font-mono-tabular text-3xl font-bold tracking-tight">$73,000</div>
          </CardContent>
        </Card>
        <Card className="glass md:col-span-1">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Loans at Risk</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="font-mono-tabular text-3xl font-bold tracking-tight text-amber">1</div>
          </CardContent>
        </Card>
      </div>

      <div className="animate-slide-up-fade" style={{ animationDelay: "200ms", animationFillMode: "both" }}>
        <LoansTable />
      </div>
    </div>
  );
}
