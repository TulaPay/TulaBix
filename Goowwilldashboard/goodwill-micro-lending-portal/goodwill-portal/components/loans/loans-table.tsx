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
import { Badge } from "@/components/ui/badge";
import { formatCurrency } from "@/lib/format";

const data = [
  { id: "LN-001", merchant: "Sarah's Cafe", principal: 25000, outstanding: 18500, nextPayment: "2023-11-01", status: "active" },
  { id: "LN-002", merchant: "TechFix Solutions", principal: 15000, outstanding: 0, nextPayment: "-", status: "paid_off" },
  { id: "LN-003", merchant: "Green Valley Farm", principal: 50000, outstanding: 45000, nextPayment: "2023-11-15", status: "active" },
  { id: "LN-004", merchant: "Downtown Retail", principal: 10000, outstanding: 9500, nextPayment: "2023-10-31", status: "late" },
];

function LoanStatusBadge({ status }: { status: string }) {
  if (status === "active") {
    return <Badge className="bg-signal/10 text-signal hover:bg-signal/20 font-medium border-0">Active</Badge>;
  }
  if (status === "late") {
    return <Badge className="bg-amber/10 text-amber hover:bg-amber/20 font-medium border-0">Late</Badge>;
  }
  if (status === "paid_off") {
    return <Badge className="bg-surface-muted text-muted-foreground hover:bg-surface-muted font-medium border-0">Paid Off</Badge>;
  }
  return <Badge variant="outline">{status}</Badge>;
}

export function LoansTable() {
  const router = useRouter();

  return (
    <div className="rounded-xl border border-border/50 bg-surface/50 backdrop-blur-sm overflow-hidden shadow-sm">
      <Table>
        <TableHeader className="bg-surface-muted/50">
          <TableRow className="hover:bg-transparent border-border/50">
            <TableHead className="w-[100px]">ID</TableHead>
            <TableHead>Merchant</TableHead>
            <TableHead>Principal</TableHead>
            <TableHead>Outstanding</TableHead>
            <TableHead>Next Payment</TableHead>
            <TableHead className="text-right">Status</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {data.map((loan) => (
            <TableRow 
              key={loan.id}
              onClick={() => router.push(`/loans/${loan.id}`)}
              className="cursor-pointer hover:bg-surface/80 transition-colors border-border/50"
            >
              <TableCell className="font-medium text-muted-foreground">{loan.id}</TableCell>
              <TableCell className="font-semibold">{loan.merchant}</TableCell>
              <TableCell className="font-mono-tabular text-muted-foreground">
                {formatCurrency(loan.principal)}
              </TableCell>
              <TableCell className="font-mono-tabular font-medium">
                {formatCurrency(loan.outstanding)}
              </TableCell>
              <TableCell className="text-muted-foreground text-sm">
                {loan.nextPayment}
              </TableCell>
              <TableCell className="text-right">
                <LoanStatusBadge status={loan.status} />
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
