import { BadgeCheck, Clock, ShieldAlert, Wallet2 } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { formatDate } from "@/lib/format";
import type { MerchantProfile } from "@/lib/types/application";
import { cn } from "@/lib/utils";

const KYC_CONFIG = {
  verified: { label: "Verified", icon: BadgeCheck, className: "text-signal" },
  pending: { label: "Pending review", icon: Clock, className: "text-amber" },
  flagged: { label: "Flagged", icon: ShieldAlert, className: "text-danger" },
} as const;

export function MerchantOverviewCard({ merchant }: { merchant: MerchantProfile }) {
  const kyc = KYC_CONFIG[merchant.kycStatus];
  const KycIcon = kyc.icon;

  return (
    <Card>
      <CardHeader className="flex-row items-start justify-between space-y-0">
        <div>
          <CardTitle className="text-base">{merchant.businessName}</CardTitle>
          <p className="mt-0.5 text-xs text-muted-foreground">
            Merchant since {formatDate(merchant.memberSince)} ·{" "}
            <span className="capitalize">{merchant.revenueTier} tier</span>
          </p>
        </div>
        <div className={cn("flex items-center gap-1.5 text-xs font-medium", kyc.className)}>
          <KycIcon className="h-4 w-4" />
          {kyc.label}
        </div>
      </CardHeader>
      <CardContent className="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <div>
          <p className="text-xs text-muted-foreground">Owner</p>
          <p className="text-sm font-medium">{merchant.ownerName}</p>
          <p className="text-xs text-muted-foreground">{merchant.ownerEmail}</p>
          <p className="text-xs text-muted-foreground">{merchant.ownerPhone}</p>
        </div>
        <div>
          <p className="text-xs text-muted-foreground">Linked account</p>
          <div className="mt-1 flex items-center gap-1.5 text-sm font-medium">
            <Wallet2 className="h-3.5 w-3.5 text-muted-foreground" />
            {merchant.linkedAccount.provider}
          </div>
          <p className="font-mono-tabular text-xs text-muted-foreground">
            •••• {merchant.linkedAccount.accountLast4}
          </p>
        </div>
        <div>
          <p className="text-xs text-muted-foreground">Merchant ID</p>
          <p className="font-mono-tabular text-sm font-medium">{merchant.id}</p>
        </div>
      </CardContent>
    </Card>
  );
}
