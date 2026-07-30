"use client";

import { motion } from "framer-motion";
import { Search, Filter } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export function ApplicationsFilters() {
  return (
    <motion.div 
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      className="flex flex-col sm:flex-row gap-4 justify-between items-center bg-surface/50 p-4 rounded-xl border border-border/50 mb-6 backdrop-blur-md"
    >
      <div className="relative w-full sm:max-w-xs">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
        <Input 
          placeholder="Search merchants..." 
          className="pl-9 bg-background/50 border-border/50 focus-visible:ring-signal"
        />
      </div>
      
      <div className="flex w-full sm:w-auto gap-3">
        <Button variant="outline" className="flex-1 sm:flex-none gap-2 bg-surface hover:bg-surface-muted">
          <Filter className="h-4 w-4" />
          Status
        </Button>
        <Button variant="outline" className="flex-1 sm:flex-none gap-2 bg-surface hover:bg-surface-muted">
          <Filter className="h-4 w-4" />
          Risk Tier
        </Button>
      </div>
    </motion.div>
  );
}
