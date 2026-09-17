import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

// Bank Transfer, Internal Transfer, Statements, and Add Customer used to be
// demo shells here with no-op actions. They're now real: TransferScreen
// (lib/screens/transfer_screen.dart), StatementsScreen
// (lib/screens/statements_screen.dart), and the existing Customers tab's
// own Add Customer flow. Only POS Settings remains below, honestly labeled
// as not built yet rather than pretending to save.

class PosSettingsDemoScreen extends StatelessWidget {
  const PosSettingsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'POS Settings',
      subtitle: 'Checkout preferences, receipts, and payment behavior.',
      icon: Icons.settings_applications_outlined,
      actionLabel: null,
      children: const [
        GlassInfoCard(
          icon: Icons.hourglass_empty_rounded,
          title: 'Coming soon',
          subtitle:
              'Receipt format, checkout modes, and terminal controls aren\'t '
              'built yet — nothing here is saved.',
        ),
      ],
    );
  }
}
