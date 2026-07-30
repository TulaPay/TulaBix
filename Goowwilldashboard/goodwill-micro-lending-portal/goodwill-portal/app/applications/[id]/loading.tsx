import { Skeleton } from "@/components/ui/skeleton";

export default function LoadingApplicationDetail() {
  return (
    <div className="space-y-6 pb-12">
      <Skeleton className="h-4 w-40" />
      <div className="flex items-center justify-between">
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-6 w-24 rounded-full" />
      </div>
      <Skeleton className="h-40 w-full rounded-lg" />
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <Skeleton className="h-80 w-full rounded-lg lg:col-span-2" />
        <Skeleton className="h-80 w-full rounded-lg" />
      </div>
      <Skeleton className="h-64 w-full rounded-lg" />
    </div>
  );
}
