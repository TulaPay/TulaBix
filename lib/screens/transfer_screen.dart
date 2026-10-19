import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/ledger.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/pin_prompt.dart';

/// Real bank/internal transfer screen — backs both the "Bank Transfer" and
/// "Internal Transfer" tiles in More Actions. Calls the already-existing
/// `initiate_transfer` RPC via [MerchantRepository.initiateTransfer].
class TransferScreen extends StatefulWidget {
  final String kind; // 'bank' | 'internal'
  const TransferScreen({super.key, required this.kind});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late Future<List<MerchantTransfer>> _transfersFuture;
  bool _submitting = false;

  bool get _isBank => widget.kind == 'bank';
  String get _title => _isBank ? 'Bank Transfer' : 'Internal Transfer';
  String get _sourceLabel => _isBank ? 'Bank account' : 'Source wallet';
  String get _destinationLabel =>
      _isBank ? 'Beneficiary account' : 'Destination wallet';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _transfersFuture = MerchantRepository.instance.transfers().then(
          (list) => list.where((t) => t.kind == widget.kind).toList(),
        );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final source = _sourceController.text.trim();
    final destination = _destinationController.text.trim();
    final amount = num.tryParse(_amountController.text.trim());

    if (source.isEmpty) {
      AppFeedback.toast(context, 'Enter the $_sourceLabel');
      return;
    }
    if (destination.isEmpty) {
      AppFeedback.toast(context, 'Enter the $_destinationLabel');
      return;
    }
    if (amount == null || amount <= 0) {
      AppFeedback.toast(context, 'Enter a valid amount');
      return;
    }

    final verified = await PinPrompt.show(context);
    if (!mounted || !verified) return;

    setState(() => _submitting = true);
    try {
      final note = _noteController.text.trim();
      final transfer = await MerchantRepository.instance.initiateTransfer(
        kind: widget.kind,
        source: source,
        destination: destination,
        amount: amount,
        note: note.isEmpty ? null : note,
      );
      if (!mounted) return;
      _sourceController.clear();
      _destinationController.clear();
      _amountController.clear();
      _noteController.clear();
      setState(_refresh);
      PushNotificationService.instance.showNotification(
        title: _isBank ? 'Bank Transfer Submitted' : 'Internal Transfer Completed',
        body: '${money(amount)} transfer to $destination',
      );
      if (widget.kind == 'bank') {
        try {
          await MerchantRepository.instance.initiatePayout(transfer.id);
          if (!mounted) return;
          AppFeedback.toast(
            context,
            'Transfer submitted and payout initiated successfully',
            duration: const Duration(seconds: 5),
          );
        } catch (payoutError) {
          if (!mounted) return;
          AppFeedback.toast(
            context,
            'Transfer recorded, but payout failed: $payoutError',
            duration: const Duration(seconds: 8),
          );
        }
      } else {
        AppFeedback.toast(context, 'Transfer submitted');
      }
    } catch (e) {
      if (!mounted) return;
      AppFeedback.toast(context, 'Could not submit transfer: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _statusLabel(String status) => switch (status) {
        'pending' => 'Pending',
        'completed' => 'Completed',
        'failed' => 'Failed',
        _ => status,
      };

  Color _statusColor(String status, ColorScheme cs) => switch (status) {
        'pending' => AppColors.warning,
        'completed' => AppColors.positive,
        'failed' => cs.error,
        _ => cs.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(_title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'TRANSFER DETAILS',
                  style: AppText.microLabel(color: context.textTertiary)
                      .copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 14),
                GlassSurface(
                  child: Column(
                    children: [
                      _Field(
                        label: _sourceLabel,
                        hint: _isBank ? 'Merchant payout account' : 'e.g. Main wallet',
                        controller: _sourceController,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: _destinationLabel,
                        hint: _isBank ? 'IBAN / account number' : 'e.g. Savings wallet',
                        controller: _destinationController,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Amount',
                        hint: '0.00',
                        controller: _amountController,
                        prefix: 'XAF',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Note',
                        hint: 'Optional memo',
                        controller: _noteController,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _submitting ? null : _handleSubmit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Submit transfer'),
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 8),
                Text(
                  'RECENT TRANSFERS',
                  style: AppText.microLabel(color: context.textTertiary)
                      .copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<MerchantTransfer>>(
                  future: _transfersFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final list = snap.data ?? const [];
                    if (list.isEmpty) {
                      return Text(
                        'No transfers yet.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final t in list) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: context.hairlineColor),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${t.sourceLabel} → ${t.destinationLabel}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM d, h:mm a').format(t.createdAt),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      money(t.amount),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _statusLabel(t.status),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: _statusColor(t.status, cs),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? prefix;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefix,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.microLabel(color: context.textTertiary)
              .copyWith(fontSize: 10, letterSpacing: 1.4),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixText: prefix == null ? null : '$prefix ',
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: context.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
