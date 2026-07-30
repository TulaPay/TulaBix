"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";
import { formatCurrency } from "@/lib/format";

const data = [
  { month: "Jan", disbursed: 40000, repaid: 24000 },
  { month: "Feb", disbursed: 30000, repaid: 13980 },
  { month: "Mar", disbursed: 20000, repaid: 9800 },
  { month: "Apr", disbursed: 27800, repaid: 39080 },
  { month: "May", disbursed: 18900, repaid: 48000 },
  { month: "Jun", disbursed: 23900, repaid: 38000 },
  { month: "Jul", disbursed: 34900, repaid: 43000 },
];

export function DisbursementChart() {
  const { theme, systemTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => setMounted(true), []);

  if (!mounted) return <div className="h-[300px] w-full animate-pulse bg-surface-muted rounded-xl" />;

  const currentTheme = theme === "system" ? systemTheme : theme;
  const isDark = currentTheme === "dark";

  const colors = {
    disbursed: isDark ? "hsl(210 40% 98%)" : "hsl(222 47% 11%)", // ink
    repaid: isDark ? "hsl(217 91% 60%)" : "hsl(221 83% 53%)", // signal blue
  };

  return (
    <Card className="glass h-full">
      <CardHeader>
        <CardTitle className="text-lg">Capital Flow</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="h-[300px] w-full">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={data} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
              <defs>
                <linearGradient id="colorDisbursed" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor={colors.disbursed} stopOpacity={0.1} />
                  <stop offset="95%" stopColor={colors.disbursed} stopOpacity={0} />
                </linearGradient>
                <linearGradient id="colorRepaid" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor={colors.repaid} stopOpacity={0.1} />
                  <stop offset="95%" stopColor={colors.repaid} stopOpacity={0} />
                </linearGradient>
              </defs>
              <XAxis 
                dataKey="month" 
                axisLine={false} 
                tickLine={false} 
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} 
                dy={10}
              />
              <YAxis 
                axisLine={false} 
                tickLine={false} 
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
                tickFormatter={(value) => `$${value / 1000}k`}
              />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: "hsl(var(--surface))",
                  borderColor: "hsl(var(--border))",
                  borderRadius: "8px",
                  boxShadow: "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)"
                }}
                formatter={(value: number) => formatCurrency(value)}
              />
              <Area 
                type="monotone" 
                dataKey="disbursed" 
                stroke={colors.disbursed} 
                strokeWidth={2}
                fillOpacity={1} 
                fill="url(#colorDisbursed)" 
              />
              <Area 
                type="monotone" 
                dataKey="repaid" 
                stroke={colors.repaid} 
                strokeWidth={2}
                fillOpacity={1} 
                fill="url(#colorRepaid)" 
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}
