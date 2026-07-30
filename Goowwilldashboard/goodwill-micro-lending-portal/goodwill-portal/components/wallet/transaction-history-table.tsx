"use client";

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ArrowDownLeft, ArrowUpRight } from "lucide-react";
import { formatCurrency } from "@/lib/format";

const transactions = [
  { id: "TX-1049", type: "inbound", amount: 150000, description: "Fund Injection from LP", date: "2023-10-26", status: "completed" },
  { id: "TX-1048", type: "outbound", amount: 25000, description: "Disbursement: LN-001", date: "2023-10-25", status: "completed" },
  { id: "TX-1047", type: "inbound", amount: 1250, description: "Repayment: LN-002", date: "2023-10-25", status: "completed" },
  { id: "TX-1046", type: "outbound", amount: 50000, description: "Disbursement: LN-003", date: "2023-10-24", status: "completed" },
];

export function TransactionHistoryTable() {
  return (
    <div className="rounded-xl border border-border/50 bg-surface/50 backdrop-blur-sm overflow-hidden shadow-sm mt-6">
      <Table>
        <TableHeader className="bg-surface-muted/50">
          <TableRow className="hover:bg-transparent border-border/50">
            <TableHead className="w-[100px]">ID</TableHead>
            <TableHead>Type</TableHead>
            <TableHead>Description</TableHead>
            <TableHead>Date</TableHead>
            <TableHead className="text-right">Amount</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {transactions.map((tx) => {
            const isOutbound = tx.type === "outbound";
            const TxIcon = isOutbound ? ArrowUpRight : ArrowDownLeft;
            return (
              <TableRow key={tx.id} className="hover:bg-surface/80 transition-colors border-border/50">
                <TableCell className="font-medium text-muted-foreground">{tx.id}</TableCell>
                <TableCell>
                  <div className={`flex items-center gap-2 ${isOutbound ? "text-amber" : "text-signal"}`}>
                    <div className={`rounded-full p-1 ${isOutbound ? "bg-amber/10" : "bg-signal/10"}`}>
                      <TxIcon className="h-3 w-3" />
                    </div>
                    <span className="capitalize">{tx.type}</span>
                  </div>
                </TableCell>
                <TableCell>{tx.description}</TableCell>
                <TableCell className="text-muted-foreground">{tx.date}</TableCell>
                <TableCell className={`text-right font-mono-tabular font-medium ${isOutbound ? "" : "text-signal"}`}>
                  {isOutbound ? "-" : "+"}{formatCurrency(tx.amount)}
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </div>
  );
}
