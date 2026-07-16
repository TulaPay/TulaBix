import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Billing',
      subtitle: 'Manage payment methods, invoices, and settlement routes.',
      icon: Icons.credit_card_rounded,
      actionLabel: 'Add method',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.wallet_rounded,
          title: 'Payment methods',
          subtitle: 'Cards, bank accounts, and wallet destinations.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.receipt_long_rounded,
          title: 'Transaction history',
          subtitle: 'Review settlement entries and billing records.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.description_outlined,
          title: 'Invoices',
          subtitle: 'Track invoices, statements, and downloadable records.',
        ),
      ],
    );
  }
}
