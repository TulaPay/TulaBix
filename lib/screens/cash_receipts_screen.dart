import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/pin_prompt.dart';

class CashReceiptsScreen extends StatefulWidget {
  const CashReceiptsScreen({super.key});

  @override
  State<CashReceiptsScreen> createState() => _CashReceiptsScreenState();
}

class _CashReceiptsScreenState extends State<CashReceiptsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = 'General';
  bool _submitting = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'General', 'icon': Icons.grid_view_rounded},
    {'name': 'Food', 'icon': Icons.restaurant_rounded},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'name': 'Services', 'icon': Icons.handyman_rounded},
    {'name': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _itemController.dispose();
    _customerController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    final amount = num.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      AppFeedback.toast(context, 'Enter a valid amount');
      return;
    }

    final verified = await PinPrompt.show(context);
    if (!mounted || !verified) return;

    setState(() => _submitting = true);
    try {
      final item = _itemController.text.trim();
      final customer = _customerController.text.trim();
      final note = _noteController.text.trim();
      await MerchantRepository.instance.recordCashReceipt(
        amount: amount,
        category: item.isEmpty ? _selectedCategory : '$_selectedCategory — $item',
        customerName: customer.isEmpty ? null : customer,
        note: note.isEmpty ? null : note,
      );
      if (!mounted) return;
      _amountController.clear();
      _itemController.clear();
      _customerController.clear();
      _noteController.clear();
      AppFeedback.toast(context, 'Receipt recorded');
      PushNotificationService.instance.showNotification(
        title: 'Cash Payment Received',
        body: 'Recorded ${money(amount)}${customer.isNotEmpty ? ' from $customer' : ''}',
      );
    } catch (e) {
      if (!mounted) return;
      AppFeedback.toast(context, 'Could not record receipt: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => const _CashReceiptHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Cash Receipt",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _showHistory,
            icon: const Icon(Icons.history_rounded),
            tooltip: "History",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record a cash sale',
                    style: AppText.screenTitle(size: 20, color: cs.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create a clean receipt with a clear amount and item description.',
                    style: AppText.body(size: 14, color: context.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassSurface(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  tint: context.primaryTintColor,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL SALE AMOUNT',
                        style: AppText.microLabel(color: cs.primary)
                            .copyWith(letterSpacing: 1.6),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'XAF',
                            style: GoogleFonts.plusJakartaSans(
                              color: context.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.2,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                filled: false,
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: context.textTertiary,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'CATEGORY',
                  style: AppText.microLabel(color: context.textTertiary)
                      .copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['name'];
                      final accent = cs.primary;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedCategory = cat['name']);
                          },
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: GlassSurface(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : context.hairlineColor,
                            ),
                            child: SizedBox(
                              width: 72,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.sm),
                                      color: context.primaryTintColor,
                                    ),
                                    child: Icon(
                                      cat['icon'],
                                      color: accent,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cat['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isSelected
                                          ? cs.onSurface
                                          : context.textSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'RECEIPT DETAILS',
                  style: AppText.microLabel(color: context.textTertiary)
                      .copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 12),
                GlassSurface(
                  child: Column(
                    children: [
                      _FieldRow(
                        label: 'Item or service',
                        hint: 'e.g. Graphic design',
                        controller: _itemController,
                        icon: Icons.shopping_bag_outlined,
                      ),
                      const SizedBox(height: 16),
                      _FieldRow(
                        label: 'Customer name',
                        hint: 'Optional',
                        controller: _customerController,
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                      _FieldRow(
                        label: 'Note',
                        hint: 'Add a short receipt note',
                        controller: _noteController,
                        icon: Icons.sticky_note_2_outlined,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUMMARY',
                        style: AppText.microLabel(color: context.textTertiary)
                            .copyWith(letterSpacing: 1.6),
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(label: 'Category', value: _selectedCategory),
                      _SummaryRow(label: 'Payment mode', value: 'Cash'),
                      _SummaryRow(
                        label: 'Status',
                        value: _submitting ? 'Recording…' : 'Ready to generate',
                        valueColor: cs.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submitting ? null : _handleGenerate,
                    icon: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.receipt_long_rounded),
                    label: Text(
                      _submitting ? 'Recording…' : 'Generate receipt',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;

  const _FieldRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
                        Text(
              label.toUpperCase(),
              style: AppText.microLabel(color: context.textTertiary)
                  .copyWith(fontSize: 10, letterSpacing: 1.4),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
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

class _CashReceiptHistorySheet extends StatefulWidget {
  const _CashReceiptHistorySheet();

  @override
  State<_CashReceiptHistorySheet> createState() =>
      _CashReceiptHistorySheetState();
}

class _CashReceiptHistorySheetState extends State<_CashReceiptHistorySheet> {
  late final Future<List<CashReceipt>> _future =
      MerchantRepository.instance.cashReceipts();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent cash receipts',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: FutureBuilder<List<CashReceipt>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final receipts = snap.data ?? const [];
                if (receipts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No cash receipts recorded yet.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: receipts.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, i) {
                    final r = receipts[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                                  r.category,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: cs.onSurface,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d, h:mm a').format(r.createdAt),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            money(r.amount),
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: valueColor ?? cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
