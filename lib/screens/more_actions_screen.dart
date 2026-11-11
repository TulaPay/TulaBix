import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/Customer_Screen.dart';
import 'package:tulapay/screens/more_actions_demos.dart';
import 'package:tulapay/screens/statements_screen.dart';
import 'package:tulapay/screens/transfer_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

// Bank Transfer and Collect Payment moved to Homepage's own Quick Actions
// row — removed from here rather than duplicated, matching how Payment
// Links/My QR Code/Cash Receipts already live only in Quick Actions, never
// in this grid.
class MoreActionsScreen extends StatelessWidget {
  const MoreActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final actions = [
      {
        'icon': Icons.swap_horiz_rounded,
        'label': context.l10n.internalTransfer,
        'route': 'internal_transfer',
      },
      {
        'icon': Icons.history_edu_rounded,
        'label': context.l10n.statements,
        'route': 'statements',
      },
      {
        'icon': Icons.group_add_rounded,
        'label': context.l10n.addCustomer,
        'route': 'add_customer',
      },
      {
        'icon': Icons.settings_applications_outlined,
        'label': context.l10n.posSettings,
        'route': 'pos_settings',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          context.l10n.allActions,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
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
          final isNavigable = route != null;

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
              if (route == 'internal_transfer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransferScreen(kind: 'internal'),
                  ),
                );
              } else if (route == 'statements') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatementsScreen()),
                );
              } else if (route == 'add_customer') {
                // Redirects to the real Customers tab's own Add Customer
                // flow instead of duplicating a second entry point.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerScreen()),
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
