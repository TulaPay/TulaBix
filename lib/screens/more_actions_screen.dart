import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/products_screen.dart';

class MoreActionsScreen extends StatelessWidget {
  const MoreActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final actions = [
      {'icon': Icons.account_balance_rounded, 'label': 'Bank Transfer', 'route': null},
      {'icon': Icons.swap_horiz_rounded, 'label': 'Internal Transfer', 'route': null},
      {'icon': Icons.history_edu_rounded, 'label': 'Statements', 'route': null},
      {'icon': Icons.group_add_rounded, 'label': 'Add Customer', 'route': null},
      {'icon': Icons.inventory_2_outlined, 'label': 'Inventory', 'route': 'products'},
      {'icon': Icons.settings_applications_outlined, 'label': 'POS Settings', 'route': null},
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
          final route = action['route'] as String?;
          return GestureDetector(
            onTap: () {
              if (route == 'products') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsScreen()),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: route != null
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.secondaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: route != null ? colorScheme.primary : colorScheme.secondary,
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
            ),
          );
        },
      ),
    );
  }
}
