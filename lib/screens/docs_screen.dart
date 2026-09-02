import 'package:flutter/material.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  static const _base = 'https://docs.tulabix.com';

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Documentation',
      subtitle: 'Guides, product notes, and implementation references.',
      icon: Icons.menu_book_rounded,
      actionLabel: 'Open docs',
      onAction: () => AppFeedback.launch(context, _base),
      children: [
        GlassInfoCard(
          icon: Icons.play_circle_outline_rounded,
          title: 'Getting started',
          subtitle: 'Product setup and your first sale.',
          onTap: () => AppFeedback.launch(context, '$_base/getting-started'),
        ),
        const SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.api_rounded,
          title: 'Feature guides',
          subtitle: 'Payments, drawer, and settings flows explained.',
          onTap: () => AppFeedback.launch(context, '$_base/guides'),
        ),
        const SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.bug_report_outlined,
          title: 'Troubleshooting',
          subtitle: 'Common issues and what to check first.',
          onTap: () => AppFeedback.launch(context, '$_base/troubleshooting'),
        ),
      ],
    );
  }
}
