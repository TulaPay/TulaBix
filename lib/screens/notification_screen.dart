import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Notifications',
      subtitle: 'Stay on top of alerts, reminders, and activity updates.',
      icon: Icons.notifications_active_rounded,
      actionLabel: 'Mark all read',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.campaign_rounded,
          title: 'Promotional alert',
          subtitle: 'A new seasonal promotion is ready to review.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.payment_rounded,
          title: 'Payment confirmation',
          subtitle: 'A customer payment landed successfully a few moments ago.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.warning_amber_rounded,
          title: 'Action needed',
          subtitle: 'One transfer is pending verification and may need attention.',
        ),
      ],
    );
  }
}
