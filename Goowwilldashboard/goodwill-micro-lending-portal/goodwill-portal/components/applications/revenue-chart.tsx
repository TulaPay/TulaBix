"use client";

import {
  ResponsiveContainer,
  ComposedChart,
  Area,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
} from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { formatCurrency, formatDate } from "@/lib/format";
import type { RevenuePoint } from "@/lib/types/application";

export function RevenueChart({ data }: { data: RevenuePoint[] }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Revenue & order volume</CardTitle>
        <CardDescription>Last 90 days, synced from the core sales app</CardDescription>
      </CardHeader>
      <CardContent className="h-[280px] pl-0">
        <ResponsiveContainer width="100%" height="100%">
          <ComposedChart data={data} margin={{ top: 8, right: 16, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="revenueFill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="hsl(var(--signal))" stopOpacity={0.25} />
                <stop offset="100%" stopColor="hsl(var(--signal))" stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid stroke="hsl(var(--border))" vertical={false} />
            <XAxis
              dataKey="date"
              tickFormatter={(d) => formatDate(d)}
              tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }}
              axisLine={{ stroke: "hsl(var(--border))" }}
              tickLine={false}
              minTickGap={32}
            />
            <YAxis
              yAxisId="revenue"
              tickFormatter={(v) => formatCurrency(v)}
              tick={{ fontSize: 11, fill: "hsl(var(--muted-foreground))" }}
              axisLine={false}
              tickLine={false}
              width={64}
            />
            <YAxis yAxisId="orders" orientation="right" hide />
            <Tooltip
              contentStyle={{
                background: "hsl(var(--surface))",
                border: "1px solid hsl(var(--border))",
                borderRadius: 8,
                fontSize: 12,
              }}
              labelFormatter={(d) => formatDate(d as string)}
              formatter={(value: number, name: string) =>
                name === "revenue" ? [formatCurrency(value), "Revenue"] : [value, "Orders"]
              }
            />
            <Area
              yAxisId="revenue"
              type="monotone"
              dataKey="revenue"
              stroke="hsl(var(--signal))"
              fill="url(#revenueFill)"
              strokeWidth={2}
            />
            <Bar
              yAxisId="orders"
              dataKey="orders"
              fill="hsl(var(--amber) / 0.35)"
              radius={[3, 3, 0, 0]}
              barSize={4}
            />
          </ComposedChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  );
}
