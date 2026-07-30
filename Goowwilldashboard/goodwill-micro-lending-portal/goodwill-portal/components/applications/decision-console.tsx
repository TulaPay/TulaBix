"use client";

import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { DecisionConfirmDialog } from "@/components/applications/decision-confirm-dialog";
import { useToast } from "@/hooks/use-toast";
import type { LoanApplication } from "@/lib/types/application";

interface DecisionConsoleProps {
  application: LoanApplication;
  onDecision: (payload: {
    action: "approve" | "decline";
    amount: number;
    interestRate: number;
    tenureMonths: number;
    dailyDeductionPercent: number;
    notes: string;
  }) => Promise<void>;
}

export function DecisionConsole({ application, onDecision }: DecisionConsoleProps) {
  const { toast } = useToast();
  const [amount, setAmount] = useState(application.credit.maxRecommendedLoan);
  const [interestRate, setInterestRate] = useState(4.5);
  const [tenureMonths, setTenureMonths] = useState(application.requestedTenureMonths);
  const [dailyDeductionPercent, setDailyDeductionPercent] = useState(8);
  const [notes, setNotes] = useState("");
  const [pendingAction, setPendingAction] = useState<"approve" | "decline" | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const notesRequired = notes.trim().length === 0;

  async function handleConfirm() {
    if (!pendingAction) return;
    setIsSubmitting(true);
    try {
      await onDecision({
        action: pendingAction,
        amount,
        interestRate,
        tenureMonths,
        dailyDeductionPercent,
        notes,
      });
      toast({
        title: pendingAction === "approve" ? "Loan approved" : "Application declined",
        description:
          pendingAction === "approve"
            ? "Disbursement instruction sent to the wallet."
            : "The merchant has been notified.",
      });
    } catch (err) {
      toast({
        title: "Something went wrong",
        description: "The decision could not be sent to the core backend. Try again.",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
      setPendingAction(null);
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Decision console</CardTitle>
        <CardDescription>
          Requested {application.requestedTenureMonths} months ·{" "}
          {application.requestedAmount.toLocaleString("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 0,
          })}
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <Field label="Approved amount" prefix="$">
            <Input
              type="number"
              value={amount}
              min={0}
              onChange={(e) => setAmount(Number(e.target.value))}
              className="font-mono-tabular"
            />
          </Field>
          <Field label="Interest rate" suffix="%">
            <Input
              type="number"
              step="0.1"
              value={interestRate}
              min={0}
              onChange={(e) => setInterestRate(Number(e.target.value))}
              className="font-mono-tabular"
            />
          </Field>
          <Field label="Tenure" suffix="months">
            <Input
              type="number"
              value={tenureMonths}
              min={1}
              onChange={(e) => setTenureMonths(Number(e.target.value))}
              className="font-mono-tabular"
            />
          </Field>
          <Field label="Daily deduction" suffix="% of sales">
            <Input
              type="number"
              step="0.5"
              value={dailyDeductionPercent}
              min={0}
              max={100}
              onChange={(e) => setDailyDeductionPercent(Number(e.target.value))}
              className="font-mono-tabular"
            />
          </Field>
        </div>

        <div>
          <label className="mb-1.5 block text-xs font-medium text-muted-foreground">
            Decision notes <span className="text-danger">(required)</span>
          </label>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            rows={3}
            placeholder="Explain the reasoning behind this decision — this is stored on the merchant's file."
            className="w-full rounded-md border border-border bg-transparent px-3 py-2 text-sm outline-none focus-visible:outline-none"
          />
        </div>

        <div className="flex gap-3 pt-1">
          <Button
            variant="signal"
            className="flex-1"
            disabled={notesRequired || amount <= 0}
            onClick={() => setPendingAction("approve")}
          >
            Approve & set terms
          </Button>
          <Button
            variant="outline"
            className="flex-1"
            disabled={notesRequired}
            onClick={() => setPendingAction("decline")}
          >
            Decline application
          </Button>
        </div>
        {notesRequired && (
          <p className="text-xs text-muted-foreground">
            Add a note before approving or declining — it's sent with the webhook to the core app.
          </p>
        )}
      </CardContent>

      <DecisionConfirmDialog
        open={pendingAction !== null}
        onOpenChange={(open) => !open && setPendingAction(null)}
        action={pendingAction ?? "approve"}
        amount={amount}
        interestRate={interestRate}
        tenureMonths={tenureMonths}
        isSubmitting={isSubmitting}
        onConfirm={handleConfirm}
      />
    </Card>
  );
}

function Field({
  label,
  prefix,
  suffix,
  children,
}: {
  label: string;
  prefix?: string;
  suffix?: string;
  children: React.ReactNode;
}) {
  return (
    <div>
      <label className="mb-1.5 block text-xs font-medium text-muted-foreground">{label}</label>
      <div className="flex items-center gap-1.5">
        {prefix && <span className="text-sm text-muted-foreground">{prefix}</span>}
        {children}
        {suffix && <span className="whitespace-nowrap text-xs text-muted-foreground">{suffix}</span>}
      </div>
    </div>
  );
}
