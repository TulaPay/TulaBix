import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/products_screen.dart';
import 'package:tulapay/screens/more_actions_demos.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class MoreActionsScreen extends StatelessWidget {
  const MoreActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final actions = [
      {
        'icon': Icons.account_balance_rounded,
        'label': 'Bank Transfer',
        'route': 'bank_transfer',
      },
      {
        'icon': Icons.swap_horiz_rounded,
        'label': 'Internal Transfer',
        'route': 'internal_transfer',
      },
      {
        'icon': Icons.history_edu_rounded,
        'label': 'Statements',
        'route': 'statements',
      },
      {
        'icon': Icons.group_add_rounded,
        'label': 'Add Customer',
        'route': 'add_customer',
      },
      {
        'icon': Icons.inventory_2_outlined,
        'label': 'Inventory',
        'route': 'products',
      },
      {
        'icon': Icons.settings_applications_outlined,
        'label': 'POS Settings',
        'route': 'pos_settings',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "All Actions",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          final route = action['route'] as String?;
          final isNavigable = route == 'products' || route != null;

          return GlassActionTile(
            icon: action['icon'] as IconData,
            label: action['label'] as String,
            iconColor: isNavigable
                ? colorScheme.primary
                : colorScheme.secondary,
            accentColor: isNavigable
                ? colorScheme.primary
                : colorScheme.secondary,
            onTap: () {
              if (route == 'products') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsScreen()),
                );
              } else if (route == 'bank_transfer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BankTransferDemoScreen(),
                  ),
                );
              } else if (route == 'internal_transfer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InternalTransferDemoScreen(),
                  ),
                );
              } else if (route == 'statements') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StatementsDemoScreen(),
                  ),
                );
              } else if (route == 'add_customer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddCustomerDemoScreen(),
                  ),
                );
              } else if (route == 'pos_settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PosSettingsDemoScreen(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
