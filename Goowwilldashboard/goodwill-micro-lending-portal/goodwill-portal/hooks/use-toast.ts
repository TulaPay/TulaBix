"use client";

// Minimal toast store, API-compatible with shadcn/ui's use-toast so it can be
// swapped for the generated version without touching call sites.
import { useState, useCallback, useEffect } from "react";

export interface ToastOptions {
  title: string;
  description?: string;
  variant?: "default" | "destructive";
}

interface ToastItem extends ToastOptions {
  id: string;
}

let listeners: ((toasts: ToastItem[]) => void)[] = [];
let toasts: ToastItem[] = [];

function emit() {
  listeners.forEach((l) => l(toasts));
}

function pushToast(options: ToastOptions) {
  const id = Math.random().toString(36).slice(2);
  toasts = [...toasts, { id, ...options }];
  emit();
  setTimeout(() => {
    toasts = toasts.filter((t) => t.id !== id);
    emit();
  }, 4000);
}

export function useToast() {
  const [items, setItems] = useState<ToastItem[]>(toasts);

  useEffect(() => {
    listeners.push(setItems);
    return () => {
      listeners = listeners.filter((l) => l !== setItems);
    };
  }, []);

  const toast = useCallback((options: ToastOptions) => pushToast(options), []);

  return { toast, toasts: items };
}
