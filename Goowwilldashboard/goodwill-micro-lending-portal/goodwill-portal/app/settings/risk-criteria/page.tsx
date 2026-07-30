"use client";

import { motion } from "framer-motion";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function RiskCriteriaPage() {
  return (
    <motion.div 
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="space-y-6"
    >
      <Card className="glass">
        <CardHeader>
          <CardTitle>Risk Engine Weights</CardTitle>
          <CardDescription>
            Adjust the weighting parameters used by the credit risk engine.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label>Revenue Consistency Weight (%)</Label>
              <Input type="number" defaultValue={40} className="font-mono bg-surface/50" />
            </div>
            <div className="space-y-2">
              <Label>Credit History Weight (%)</Label>
              <Input type="number" defaultValue={35} className="font-mono bg-surface/50" />
            </div>
            <div className="space-y-2">
              <Label>Time in Business Weight (%)</Label>
              <Input type="number" defaultValue={15} className="font-mono bg-surface/50" />
            </div>
            <div className="space-y-2">
              <Label>Social/Reviews Weight (%)</Label>
              <Input type="number" defaultValue={10} className="font-mono bg-surface/50" />
            </div>
          </div>
          <Button className="bg-signal text-signal-foreground hover:bg-signal/90">Save Changes</Button>
        </CardContent>
      </Card>
    </motion.div>
  );
}
