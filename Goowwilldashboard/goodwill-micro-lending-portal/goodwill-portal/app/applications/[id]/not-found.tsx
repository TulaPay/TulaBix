import Link from "next/link";
import { FileSearch } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function ApplicationNotFound() {
  return (
    <div className="flex h-[60vh] flex-col items-center justify-center gap-3 text-center">
      <FileSearch className="h-10 w-10 text-muted-foreground" />
      <h2 className="font-display text-lg font-semibold">Application not found</h2>
      <p className="max-w-sm text-sm text-muted-foreground">
        This application may have been removed, or the ID in the link doesn't match any
        record synced from the core backend.
      </p>
      <Button asChild variant="outline" className="mt-2">
        <Link href="/applications">Back to applications queue</Link>
      </Button>
    </div>
  );
}
