"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Landmark } from "lucide-react";

export function ManualRepaymentDialog() {
  const [open, setOpen] = useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="default" className="bg-signal text-signal-foreground hover:bg-signal/90 gap-2">
          <Landmark className="h-4 w-4" />
          Record Repayment
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px] glass-dark">
        <DialogHeader>
          <DialogTitle>Record Manual Repayment</DialogTitle>
          <DialogDescription>
            Enter the amount received from the merchant. This will update the ledger immediately.
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Merchant ID or Name</label>
            <Input placeholder="e.g. LN-001 or Sarah's Cafe" className="bg-surface/50" />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Amount Received</label>
            <Input placeholder="$0.00" type="number" className="font-mono-tabular bg-surface/50" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => setOpen(false)}>Cancel</Button>
          <Button onClick={() => setOpen(false)} className="bg-signal text-signal-foreground hover:bg-signal/90">
            Confirm Repayment
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
