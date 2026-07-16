import 'package:flutter/material.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class BankTransferDemoScreen extends StatelessWidget {
  const BankTransferDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Bank Transfer',
      subtitle: 'Demo flow for sending funds to a bank account.',
      icon: Icons.account_balance_rounded,
      actionLabel: 'Start transfer',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.person_outline_rounded,
          title: 'Beneficiary',
          subtitle: 'Choose a saved recipient or add a new bank account.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.payments_outlined,
          title: 'Transfer amount',
          subtitle: 'Enter the amount and verify it before confirming.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.verified_user_outlined,
          title: 'Compliance check',
          subtitle: 'Review details, confirm fees, and submit securely.',
        ),
      ],
    );
  }
}

class InternalTransferDemoScreen extends StatelessWidget {
  const InternalTransferDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Internal Transfer',
      subtitle: 'Move balance between your internal merchant wallets.',
      icon: Icons.swap_horiz_rounded,
      actionLabel: 'Move funds',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.account_tree_outlined,
          title: 'Source wallet',
          subtitle: 'Choose the wallet that currently holds the funds.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.west_rounded,
          title: 'Destination wallet',
          subtitle: 'Move balance to the correct store or business unit.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.receipt_long_outlined,
          title: 'Transfer note',
          subtitle: 'Add a memo to keep the transaction easy to audit.',
        ),
      ],
    );
  }
}

class StatementsDemoScreen extends StatelessWidget {
  const StatementsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Statements',
      subtitle: 'Filter and export transaction statements by date and type.',
      icon: Icons.history_edu_rounded,
      actionLabel: 'Export PDF',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.date_range_rounded,
          title: 'Date range',
          subtitle: 'Select a custom period or use preset statement windows.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.filter_alt_rounded,
          title: 'Statement filters',
          subtitle: 'Show payments, refunds, payouts, or cash receipts only.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.file_download_outlined,
          title: 'Download options',
          subtitle: 'Generate CSV or PDF reports for accounting and review.',
        ),
      ],
    );
  }
}

class AddCustomerDemoScreen extends StatelessWidget {
  const AddCustomerDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Add Customer',
      subtitle:
          'Capture customer details and keep them ready for future sales.',
      icon: Icons.group_add_rounded,
      actionLabel: 'Save customer',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.person_outline_rounded,
          title: 'Identity',
          subtitle: 'Name, contact number, and email in one clean form.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.location_on_outlined,
          title: 'Business profile',
          subtitle: 'Capture company, location, or customer segment details.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.sticky_note_2_outlined,
          title: 'Notes',
          subtitle: 'Store preferences, special terms, and relationship notes.',
        ),
      ],
    );
  }
}

class PosSettingsDemoScreen extends StatelessWidget {
  const PosSettingsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'POS Settings',
      subtitle: 'Manage checkout preferences, receipts, and payment behavior.',
      icon: Icons.settings_applications_outlined,
      actionLabel: 'Save settings',
      onAction: () {},
      children: const [
        GlassInfoCard(
          icon: Icons.print_outlined,
          title: 'Receipt format',
          subtitle: 'Configure what appears on each receipt and confirmation.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.qr_code_rounded,
          title: 'Checkout modes',
          subtitle: 'Enable QR, cash, and wallet flows for the point of sale.',
        ),
        SizedBox(height: 12),
        GlassInfoCard(
          icon: Icons.tune_rounded,
          title: 'Terminal controls',
          subtitle: 'Adjust sound, auto-lock, and cashier defaults.',
        ),
      ],
    );
  }
}
