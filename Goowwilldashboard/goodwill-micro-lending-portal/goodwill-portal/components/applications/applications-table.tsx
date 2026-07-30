"use client";

import { motion } from "framer-motion";
import { useRouter } from "next/navigation";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { StatusBadge } from "@/components/applications/status-badge";
import { RiskBadge } from "@/components/applications/risk-badge";
import { formatCurrency } from "@/lib/format";

export function ApplicationsTable({ applications }: { applications: any[] }) {
  const router = useRouter();

  return (
    <div className="rounded-xl border border-border/50 bg-surface/50 backdrop-blur-sm overflow-hidden shadow-sm">
      <Table>
        <TableHeader className="bg-surface-muted/50">
          <TableRow className="hover:bg-transparent border-border/50">
            <TableHead className="w-[100px]">ID</TableHead>
            <TableHead>Merchant</TableHead>
            <TableHead>Amount</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Risk</TableHead>
            <TableHead className="text-right">Date</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {applications.map((app) => (
            <TableRow 
              key={app.id}
              onClick={() => router.push(`/applications/${app.id}`)}
              className="cursor-pointer hover:bg-surface/80 transition-colors border-border/50"
            >
              <TableCell className="font-medium text-muted-foreground">{app.id}</TableCell>
              <TableCell className="font-semibold">{app.merchant.businessName}</TableCell>
              <TableCell className="font-mono-tabular">
                {app.requestedAmount.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 })}
              </TableCell>
              <TableCell>
                <StatusBadge status={app.status as any} />
              </TableCell>
              <TableCell>
                <RiskBadge level={app.credit?.riskLevel || "medium"} />
              </TableCell>
              <TableCell className="text-right text-muted-foreground text-sm">
                {new Date(app.submittedAt).toLocaleDateString()}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
