import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class PromoCodesScreen extends StatelessWidget {
  const PromoCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Promo Codes',
      subtitle: 'Create and monitor promotional codes and campaign offers.',
      icon: Icons.local_offer_rounded,
      actionLabel: 'Create promo',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.discount_outlined,
          title: 'Limited-time offers',
          subtitle: 'Launch seasonal discounts without changing your core pricing.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.track_changes_rounded,
          title: 'Redemption tracking',
          subtitle: 'Review which codes convert and which ones need adjustment.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.campaign_outlined,
          title: 'Campaign bundles',
          subtitle: 'Group discounts by customer segment or marketing channel.',
        ),
      ],
    );
  }
}
