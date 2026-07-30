"use client";

import Link from "next/link";
import { ArrowRight, FileText, Landmark, Wallet } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { motion, Variants } from "framer-motion";
import { MetricCard } from "@/components/dashboard/metric-card";
import { DisbursementChart } from "@/components/dashboard/disbursement-chart";
import { RiskDistributionChart } from "@/components/dashboard/risk-distribution-chart";
import { ActivityFeed } from "@/components/dashboard/activity-feed";

const container: Variants = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1
    }
  }
};

const item: Variants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { type: "spring", stiffness: 300, damping: 24 } }
};

export default function DashboardPage() {
  return (
    <motion.div 
      className="space-y-8 pb-12"
      variants={container}
      initial="hidden"
      animate="show"
    >
      <motion.div variants={item}>
        <h1 className="font-display text-3xl font-bold tracking-tight">Executive Dashboard</h1>
        <p className="mt-2 text-muted-foreground">
          Goodwill Micro-Lending Portal overview and real-time capital flow.
        </p>
      </motion.div>

      <motion.div variants={item} className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <MetricCard title="Total Disbursed" value="$248,500" delta="+12.5%" trend="up" />
        <MetricCard title="Active Loans" value="142" delta="+4" trend="up" />
        <MetricCard title="Avg. Interest Rate" value="4.2%" delta="0%" trend="neutral" />
        <MetricCard title="Recovery Rate" value="98.2%" delta="+0.4%" trend="up" />
      </motion.div>

      <motion.div variants={item} className="grid gap-6 lg:grid-cols-7">
        <div className="lg:col-span-4">
          <DisbursementChart />
        </div>
        <div className="lg:col-span-3">
          <RiskDistributionChart />
        </div>
      </motion.div>

      <motion.div variants={item} className="grid gap-6 md:grid-cols-2">
        <ActivityFeed />

        <div className="space-y-6">
          <Card className="glass">
            <CardHeader>
              <CardTitle className="text-lg">Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="grid gap-4">
              <Button asChild variant="outline" className="justify-start gap-3 h-12 bg-surface/50 hover:bg-surface border-border/50">
                <Link href="/applications">
                  <FileText className="h-5 w-5 text-signal" />
                  Review Pending Applications
                  <ArrowRight className="ml-auto h-4 w-4" />
                </Link>
              </Button>
              <Button asChild variant="outline" className="justify-start gap-3 h-12 bg-surface/50 hover:bg-surface border-border/50">
                <Link href="/loans">
                  <Landmark className="h-5 w-5 text-signal" />
                  View Loan Ledger
                  <ArrowRight className="ml-auto h-4 w-4" />
                </Link>
              </Button>
              <Button asChild variant="outline" className="justify-start gap-3 h-12 bg-surface/50 hover:bg-surface border-border/50">
                <Link href="/wallet">
                  <Wallet className="h-5 w-5 text-signal" />
                  Liquidity & Wallet
                  <ArrowRight className="ml-auto h-4 w-4" />
                </Link>
              </Button>
            </CardContent>
          </Card>

          <Card className="glass">
            <CardHeader>
              <CardTitle className="text-lg">System Status</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <StatusItem label="Core Backend" status="Operational" />
                <StatusItem label="Risk Engine" status="Operational" />
                <StatusItem label="Payment Gateway" status="Operational" />
              </div>
            </CardContent>
          </Card>
        </div>
      </motion.div>
    </motion.div>
  );
}

function StatusItem({ label, status }: { label: string; status: string }) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-sm text-muted-foreground">{label}</span>
      <div className="flex items-center gap-2">
        <div className="relative flex h-2 w-2">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-signal opacity-75"></span>
          <span className="relative inline-flex rounded-full h-2 w-2 bg-signal"></span>
        </div>
        <span className="text-sm font-medium">{status}</span>
      </div>
    </div>
  );
}
