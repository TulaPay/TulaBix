"use client";

import { PieChart, Pie, Cell } from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { RiskBadge } from "@/components/applications/status-badge";
import { formatCurrency } from "@/lib/format";
import type { CreditAssessment } from "@/lib/types/application";

const MAX_SCORE = 850;

function scoreColor(score: number) {
  if (score >= 700) return "hsl(var(--signal))";
  if (score >= 550) return "hsl(var(--amber))";
  return "hsl(var(--danger))";
}

export function CreditHealthGauge({ credit }: { credit: CreditAssessment }) {
  const color = scoreColor(credit.creditHealthScore);
  const gaugeData = [
    { name: "score", value: credit.creditHealthScore },
    { name: "remainder", value: MAX_SCORE - credit.creditHealthScore },
  ];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Credit health score</CardTitle>
        <CardDescription>Calculated from 90-day sales & repayment signals</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="relative mx-auto h-[140px] w-[240px]">
          <PieChart width={240} height={140}>
            <Pie
              data={gaugeData}
              dataKey="value"
              startAngle={180}
              endAngle={0}
              innerRadius={78}
              outerRadius={100}
              stroke="none"
            >
              <Cell fill={color} />
              <Cell fill="hsl(var(--surface-muted))" />
            </Pie>
          </PieChart>
          <div className="absolute inset-x-0 bottom-2 flex flex-col items-center">
            <span className="font-mono-tabular font-display text-3xl font-semibold">
              {credit.creditHealthScore}
            </span>
            <span className="text-xs text-muted-foreground">of {MAX_SCORE}</span>
          </div>
        </div>

        <div className="mt-2 flex items-center justify-center">
          <RiskBadge level={credit.riskLevel} />
        </div>

        <div className="mt-5 flex items-center justify-between rounded-md bg-surface-muted px-4 py-3">
          <span className="text-sm text-muted-foreground">Max recommended offer</span>
          <span className="font-mono-tabular text-sm font-semibold">
            {formatCurrency(credit.maxRecommendedLoan)}
          </span>
        </div>

        <ul className="mt-4 space-y-2">
          {credit.scoringFactors.map((factor) => (
            <li key={factor.label} className="flex items-center justify-between text-xs">
              <span className="text-muted-foreground">{factor.label}</span>
              <span
                className={
                  factor.impact === "positive" ? "font-medium text-signal" : "font-medium text-danger"
                }
              >
                {factor.impact === "positive" ? "+" : "−"}
                {factor.weight}
              </span>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}
