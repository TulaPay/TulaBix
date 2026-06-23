import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreActionsScreen extends StatelessWidget {
  const MoreActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final actions = [
      {'icon': Icons.account_balance_rounded, 'label': 'Bank Transfer'},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Internal Transfer'},
      {'icon': Icons.history_edu_rounded, 'label': 'Statements'},
      {'icon': Icons.group_add_rounded, 'label': 'Add Customer'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Inventory'},
      {'icon': Icons.settings_applications_outlined, 'label': 'POS Settings'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Actions",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.8,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Column(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: colorScheme.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                action['label'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
