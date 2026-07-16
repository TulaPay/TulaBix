import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Setup Checklist',
      subtitle: 'Complete the core merchant setup before going live.',
      icon: Icons.check_circle_outline_rounded,
      actionLabel: 'Continue setup',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.person_outline_rounded,
          title: 'Verify profile',
          subtitle: 'Add business identity, contact details, and admin access.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.payments_outlined,
          title: 'Connect payments',
          subtitle: 'Configure your supported payment channels and settlement flow.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.qr_code_2_rounded,
          title: 'Enable QR',
          subtitle: 'Prepare QR payment entry for quick in-store checkout.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.inventory_2_outlined,
          title: 'Load products',
          subtitle: 'Create products so sales and inventory stay in sync.',
        ),
      ],
    );
  }
}
