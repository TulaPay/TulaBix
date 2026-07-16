import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Payments',
      subtitle: 'View payment flows, settlement status, and history at a glance.',
      icon: Icons.sync_alt_rounded,
      actionLabel: 'Review payments',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.receipt_long_rounded,
          title: 'Settlement history',
          subtitle: 'See completed, pending, and failed payment settlements.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Wallet transfers',
          subtitle: 'Track wallet inflows, payouts, and balance movements.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.history_rounded,
          title: 'Recent activity',
          subtitle: 'Monitor the latest payment actions across your business.',
        ),
      ],
    );
  }
}
