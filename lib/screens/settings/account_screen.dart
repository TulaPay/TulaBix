import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Account Information',
      subtitle: 'Business identity and merchant verification details.',
      icon: Icons.person_rounded,
      actionLabel: 'Update details',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.badge_outlined,
          title: 'Business profile',
          subtitle: 'Merchant name, registration details, and public identity.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.email_outlined,
          title: 'Contact channels',
          subtitle:
              'Primary email and support contact for business operations.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.verified_outlined,
          title: 'Verification status',
          subtitle: 'Know what is verified and what still needs review.',
        ),
      ],
    );
  }
}
