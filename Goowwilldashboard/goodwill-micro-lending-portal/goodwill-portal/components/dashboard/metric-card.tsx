"use client";

import { motion } from "framer-motion";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ArrowDownRight, ArrowUpRight } from "lucide-react";

interface MetricCardProps {
  title: string;
  value: string;
  delta: string;
  trend: "up" | "down" | "neutral";
}

export function MetricCard({ title, value, delta, trend }: MetricCardProps) {
  const isPositive = trend === "up";
  const TrendIcon = isPositive ? ArrowUpRight : ArrowDownRight;

  return (
    <motion.div whileHover={{ y: -4, transition: { duration: 0.2 } }}>
      <Card className="glass relative overflow-hidden group">
        <div className="absolute inset-0 bg-gradient-to-br from-signal/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium text-muted-foreground">{title}</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="font-mono-tabular text-3xl font-bold tracking-tight">{value}</div>
          <div className="mt-2 flex items-center text-xs">
            {trend !== "neutral" && (
              <span
                className={`flex items-center gap-1 rounded-full px-2 py-0.5 font-medium ${
                  isPositive ? "bg-signal/10 text-signal" : "bg-danger/10 text-danger"
                }`}
              >
                <TrendIcon className="h-3 w-3" />
                {delta}
              </span>
            )}
            <span className="ml-2 text-muted-foreground">vs. last month</span>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}
