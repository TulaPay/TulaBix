"use client";

import { motion } from "framer-motion";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Eye, EyeOff, Copy } from "lucide-react";
import { useState } from "react";

export default function ApiSettingsPage() {
  const [showKey, setShowKey] = useState(false);

  return (
    <motion.div 
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="space-y-6"
    >
      <Card className="glass">
        <CardHeader>
          <CardTitle>API Configuration</CardTitle>
          <CardDescription>
            Manage your API keys for integrating with the Core Backend.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-2">
            <Label>Production API Key</Label>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <Input 
                  type={showKey ? "text" : "password"} 
                  value="gw_prod_9f8b2c7e1a3d4f5h6j7k8l9m0n1p2q3r" 
                  readOnly 
                  className="font-mono bg-surface/50 pr-10"
                />
                <button 
                  type="button"
                  onClick={() => setShowKey(!showKey)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                >
                  {showKey ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
              <Button variant="outline" className="shrink-0 gap-2 bg-surface hover:bg-surface-muted">
                <Copy className="h-4 w-4" />
                Copy
              </Button>
            </div>
            <p className="text-xs text-muted-foreground">Last rotated: 45 days ago</p>
          </div>
          <Button variant="destructive" className="bg-danger/10 text-danger hover:bg-danger/20 border-0">
            Rotate Key
          </Button>
        </CardContent>
      </Card>

      <Card className="glass">
        <CardHeader>
          <CardTitle>Webhooks</CardTitle>
          <CardDescription>
            Configure webhook endpoints to receive realtime event payloads.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>Endpoint URL</Label>
            <Input placeholder="https://api.yourdomain.com/webhooks/goodwill" className="bg-surface/50" />
          </div>
          <Button className="bg-signal text-signal-foreground hover:bg-signal/90">Save Endpoint</Button>
        </CardContent>
      </Card>
    </motion.div>
  );
}
