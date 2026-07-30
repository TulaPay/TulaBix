"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency } from "@/lib/format";

export function BalanceCards() {
  return (
    <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
      <Card className="glass relative overflow-hidden group border-signal/20">
        <div className="absolute inset-0 bg-gradient-to-br from-signal/10 to-transparent opacity-50 group-hover:opacity-100 transition-opacity duration-300" />
        <CardHeader>
          <CardTitle className="text-sm font-medium text-muted-foreground">Available Liquidity</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="font-mono-tabular text-4xl font-bold tracking-tight text-signal">
            {formatCurrency(1250000)}
          </div>
          <p className="mt-2 text-xs text-muted-foreground">Ready for disbursement</p>
        </CardContent>
      </Card>
      
      <Card className="glass relative overflow-hidden group">
        <CardHeader>
          <CardTitle className="text-sm font-medium text-muted-foreground">Deployed Capital</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="font-mono-tabular text-4xl font-bold tracking-tight">
            {formatCurrency(3750000)}
          </div>
          <p className="mt-2 text-xs text-muted-foreground">Active in merchant loans</p>
        </CardContent>
      </Card>
      
      <Card className="glass relative overflow-hidden group">
        <CardHeader>
          <CardTitle className="text-sm font-medium text-muted-foreground">Total Fund Value</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="font-mono-tabular text-4xl font-bold tracking-tight">
            {formatCurrency(5000000)}
          </div>
          <p className="mt-2 text-xs text-muted-foreground">Assets under management</p>
        </CardContent>
      </Card>
    </div>
  );
}
