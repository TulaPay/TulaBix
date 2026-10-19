import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulapay/models/commerce.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/utils/money.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/pin_prompt.dart';
import 'package:tulapay/widgets/ui/list_row_card.dart' show StatusBadge;

class PaymentLinksScreen extends StatefulWidget {
  const PaymentLinksScreen({super.key});

  @override
  State<PaymentLinksScreen> createState() => _PaymentLinksScreenState();
}

class _PaymentLinksScreenState extends State<PaymentLinksScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  late Future<List<PaymentLink>> _linksFuture;
  PaymentLink? _lastGenerated;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _linksFuture = MerchantRepository.instance.paymentLinks();
  }

  void _refreshLinks() {
    // A block body, not `=> _linksFuture = ...`: setState()'s callback must
    // be void. An arrow-bodied closure that assigns an un-awaited Future
    // evaluates to that Future, and Flutter's setState() explicitly throws
    // on that ("setState() callback argument returned a Future") — the
    // exact bug that made a successful link generation show as a failure,
    // since this ran right after the real insert already succeeded.
    setState(() {
      _linksFuture = MerchantRepository.instance.paymentLinks();
    });
  }

  Future<void> _handleGenerate() async {
    final amount = num.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      AppFeedback.toast(context, 'Enter a valid amount');
      return;
    }
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      AppFeedback.toast(context, 'Add a payment description');
      return;
    }

    final verified = await PinPrompt.show(context);
    if (!mounted || !verified) return;

    setState(() => _generating = true);
    try {
      final reference = _referenceController.text.trim();
      final link = await MerchantRepository.instance.createPaymentLink(
        amount: amount,
        description: description,
        reference: reference.isEmpty ? null : reference,
      );
      if (!mounted) return;
      setState(() => _lastGenerated = link);
      _amountController.clear();
      _descriptionController.clear();
      _referenceController.clear();
      _refreshLinks();
      AppFeedback.toast(context, 'Payment link generated');
      PushNotificationService.instance.showNotification(
        title: 'Payment Link Generated',
        body: 'Created payment link for ${money(amount)} — $description',
      );
    } catch (e) {
      if (!mounted) return;
      AppFeedback.toast(context, 'Could not generate link: $e');
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _handleCopy() async {
    final link = _lastGenerated;
    if (link == null) {
      AppFeedback.toast(context, 'Generate a link first');
      return;
    }
    await AppFeedback.copy(context, link.url, label: 'Payment link copied');
  }

  Future<void> _handleShare() async {
    final link = _lastGenerated;
    if (link == null) {
      AppFeedback.toast(context, 'Generate a link first');
      return;
    }
    await AppFeedback.share('Pay ${money(link.amount, currency: link.currency)}: ${link.url}');
  }

  String _statusLabel(String status) => switch (status) {
        'active' => 'Active',
        'paid' => 'Paid',
        'expired' => 'Expired',
        'disabled' => 'Disabled',
        _ => status,
      };

  Color _statusColor(String status, ColorScheme cs) => switch (status) {
        'active' => cs.primary,
        'paid' => AppColors.positive,
        'expired' => cs.onSurfaceVariant,
        'disabled' => cs.error,
        _ => cs.onSurfaceVariant,
      };

  Widget _eyebrow(BuildContext context, String text) => Text(
        text,
        style: AppText.microLabel(color: context.textTertiary)
            .copyWith(letterSpacing: 1.6),
      );

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _referenceController.dispose();
    super.dispose();
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
          "Payment Links",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Help',
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
                  _eyebrow(context, 'CREATE A LINK'),
                  const SizedBox(height: 10),
                  Text(
                    'Create secure payment links',
                    style: AppText.screenTitle(size: 20, color: cs.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Set the amount, explain the charge, and generate a shareable link for fast checkout.',
                    style: AppText.body(size: 14, color: context.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _TrustChip(label: 'Encrypted', icon: Icons.lock_outline),
                      _TrustChip(label: 'Instant', icon: Icons.bolt_rounded),
                      _TrustChip(
                        label: 'Trackable',
                        icon: Icons.query_stats_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _eyebrow(context, 'PAYMENT DETAILS'),
                const SizedBox(height: 12),
                GlassSurface(
                  child: Column(
                    children: [
                      _FieldBlock(
                        label: 'Amount to receive',
                        hint: '0.00',
                        controller: _amountController,
                        prefix: 'XAF',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _FieldBlock(
                        label: 'Payment description',
                        hint: 'Invoice for graphic design',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _FieldBlock(
                        label: 'Reference',
                        hint: 'Optional invoice or order reference',
                        controller: _referenceController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _eyebrow(context, 'LINK ACTIONS'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.link_rounded,
                        label: _generating ? 'Generating…' : 'Generate',
                        onTap: _generating ? () {} : _handleGenerate,
                        filled: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.copy_rounded,
                        label: 'Copy',
                        onTap: _handleCopy,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        onTap: _handleShare,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _eyebrow(context, 'RECENT LINKS'),
                const SizedBox(height: 12),
                FutureBuilder<List<PaymentLink>>(
                  future: _linksFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final links = snap.data ?? const [];
                    if (links.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No payment links yet — generate one above.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final link in links) ...[
                          _RecentLinkCard(
                            title: link.description,
                            amount: money(link.amount, currency: link.currency),
                            date: DateFormat('MMM d, yyyy').format(link.createdAt),
                            status: _statusLabel(link.status),
                            accent: _statusColor(link.status, cs),
                          ),
                        ],
                      ],
                    );
                  },
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

class _FieldBlock extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? prefix;
  final int maxLines;
  final TextInputType? keyboardType;

  const _FieldBlock({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefix,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: cs.onSurfaceVariant.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = filled ? cs.onPrimary : cs.onSurface;
    return Material(
      color: filled ? cs.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: filled ? BorderSide.none : BorderSide(color: context.hairlineColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppText.caption(color: fg)
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentLinkCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String status;
  final Color accent;

  const _RecentLinkCard({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              color: accent.withValues(alpha: 0.14),
            ),
            child: Icon(Icons.link_rounded, color: accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitle(size: 14, color: cs.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppText.caption(color: context.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppText.cardTitle(size: 14, color: cs.onSurface)
                    .copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              StatusBadge(status, color: accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TrustChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.primaryTintColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
