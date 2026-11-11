import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

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
      title: context.l10n.posSettings,
      subtitle: context.l10n.checkoutPreferencesReceiptsAndPayment,
      icon: Icons.settings_applications_outlined,
      actionLabel: null,
      children: [
        GlassInfoCard(
          icon: Icons.hourglass_empty_rounded,
          title: context.l10n.comingSoon,
          subtitle:
              context.l10n.receiptFormatCheckoutModesAnd2,
        ),
      ],
    );
  }
}
