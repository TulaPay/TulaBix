"use client";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { formatCurrency, formatPercent } from "@/lib/format";

interface DecisionConfirmDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  action: "approve" | "decline";
  amount: number;
  interestRate: number;
  tenureMonths: number;
  isSubmitting: boolean;
  onConfirm: () => void;
}

export function DecisionConfirmDialog({
  open,
  onOpenChange,
  action,
  amount,
  interestRate,
  tenureMonths,
  isSubmitting,
  onConfirm,
}: DecisionConfirmDialogProps) {
  const isApprove = action === "approve";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>
            {isApprove ? "Confirm loan approval" : "Confirm application decline"}
          </DialogTitle>
          <DialogDescription>
            {isApprove
              ? "This sends a disbursement instruction to the wallet and notifies the merchant through the core app. This cannot be undone from this screen."
              : "The merchant will be notified through the core app that this application was declined."}
          </DialogDescription>
        </DialogHeader>

        {isApprove && (
          <div className="rounded-md bg-surface-muted p-4 text-sm">
            <div className="flex justify-between py-1">
              <span className="text-muted-foreground">Approved amount</span>
              <span className="font-mono-tabular font-medium">{formatCurrency(amount)}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="text-muted-foreground">Interest rate</span>
              <span className="font-mono-tabular font-medium">{formatPercent(interestRate)}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="text-muted-foreground">Tenure</span>
              <span className="font-mono-tabular font-medium">{tenureMonths} months</span>
            </div>
          </div>
        )}

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button
            variant={isApprove ? "signal" : "destructive"}
            onClick={onConfirm}
            disabled={isSubmitting}
          >
            {isSubmitting
              ? "Submitting…"
              : isApprove
              ? "Approve & disburse"
              : "Decline application"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
