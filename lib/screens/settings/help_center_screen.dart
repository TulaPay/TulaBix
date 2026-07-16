import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Help Center',
      subtitle: 'Find support channels, guides, and common answers quickly.',
      icon: Icons.support_agent_rounded,
      actionLabel: 'Contact support',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.question_answer_outlined,
          title: 'FAQs',
          subtitle: 'Common issues and product usage questions.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.chat_outlined,
          title: 'Live chat',
          subtitle: 'Talk to support during active business hours.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.email_outlined,
          title: 'Email support',
          subtitle: 'Send a detailed message with screenshots or receipts.',
        ),
      ],
    );
  }
}
