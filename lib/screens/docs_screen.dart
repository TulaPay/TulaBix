import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Documentation',
      subtitle: 'Browse guides, product notes, and implementation references.',
      icon: Icons.menu_book_rounded,
      actionLabel: 'Open docs',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.play_circle_outline_rounded,
          title: 'Getting started',
          subtitle: 'Step through the product setup and first-sale flow.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.api_rounded,
          title: 'Feature guides',
          subtitle: 'Understand the behavior of payment, drawer, and settings flows.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.bug_report_outlined,
          title: 'Troubleshooting',
          subtitle: 'Common issues, fixes, and what to check first when things break.',
        ),
      ],
    );
  }
}
