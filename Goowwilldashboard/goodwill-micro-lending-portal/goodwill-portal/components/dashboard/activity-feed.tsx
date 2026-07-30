"use client";

import { motion } from "framer-motion";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { CheckCircle2, Clock, Landmark, XCircle } from "lucide-react";

const activities = [
  {
    id: 1,
    type: "approved",
    title: "Application Approved",
    description: "Sarah's Cafe - $25,000 at 4.5%",
    time: "2 mins ago",
    icon: CheckCircle2,
    color: "text-signal",
  },
  {
    id: 2,
    type: "repayment",
    title: "Repayment Received",
    description: "TechFix Solutions - $1,250",
    time: "15 mins ago",
    icon: Landmark,
    color: "text-signal",
  },
  {
    id: 3,
    type: "review",
    title: "Manual Review Required",
    description: "Green Valley Farm - High Risk Score",
    time: "1 hour ago",
    icon: Clock,
    color: "text-amber",
  },
  {
    id: 4,
    type: "declined",
    title: "Application Declined",
    description: "Quick Stop Shop - DTI Ratio too high",
    time: "2 hours ago",
    icon: XCircle,
    color: "text-danger",
  },
];

export function ActivityFeed() {
  return (
    <Card className="glass h-full">
      <CardHeader>
        <CardTitle className="text-lg">Recent Activity</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-6">
          {activities.map((activity, index) => {
            const Icon = activity.icon;
            return (
              <motion.div
                key={activity.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.3, delay: index * 0.1 }}
                className="flex items-start gap-4"
              >
                <div className={`mt-0.5 rounded-full bg-surface-muted p-2 ${activity.color}`}>
                  <Icon className="h-4 w-4" />
                </div>
                <div className="flex-1 space-y-1">
                  <p className="text-sm font-medium leading-none">{activity.title}</p>
                  <p className="text-sm text-muted-foreground">{activity.description}</p>
                </div>
                <div className="text-xs text-muted-foreground whitespace-nowrap">
                  {activity.time}
                </div>
              </motion.div>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
