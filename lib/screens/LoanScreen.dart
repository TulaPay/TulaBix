import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

// Previously a fully fake, zero-backend feature: hardcoded "pre-approved"
// terms, an always-succeeds fake 3-second "vetting" delay, and even a debug
// toggle in the app bar that flipped between "application" and "active
// loan" views with one tap, bypassing any application at all. Real lending
// is a separate product (the Goodwill Micro-Lending Portal, nested inside
// this repo) that hasn't approved integration yet — see this project's
// INTEGRATION_STATUS.md/CLAUDE.md, which explicitly defer this screen
// alongside Goodwill. Replaced with an honest "not yet available" state,
// matching the same pattern already used for POS Settings
// (more_actions_demos.dart's PosSettingsDemoScreen).
class Loanscreen extends StatelessWidget {
  const Loanscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: context.l10n.loans,
      subtitle: context.l10n.businessFinancingThroughTulabiz,
      icon: Icons.account_balance_outlined,
      actionLabel: null,
      children: [
        GlassInfoCard(
          icon: Icons.hourglass_empty_rounded,
          title: context.l10n.notYetAvailable,
          subtitle:
              context.l10n.youReNotYetEligible2,
        ),
      ],
    );
  }
}
