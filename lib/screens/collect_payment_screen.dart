import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/widgets/pin_prompt.dart';

/// Direct mobile-money collection — the merchant enters the CUSTOMER's own
/// MTN MoMo number and PayDunya pushes a payment prompt straight to that
/// phone, no link or QR needed. MTN Cameroon only: PayDunya's SoftPay API
/// has no confirmed Orange Money Cameroon endpoint, so Orange customers
/// still need a payment link or the QR Payment Page instead.
class CollectPaymentScreen extends StatefulWidget {
  const CollectPaymentScreen({super.key});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final phone = _phoneController.text.trim();
    final amount = num.tryParse(_amountController.text.trim());

    if (phone.isEmpty) {
      AppFeedback.toast(context, "Enter the customer's MTN MoMo number");
      return;
    }
    if (amount == null || amount < 200) {
      AppFeedback.toast(context, 'Enter an amount of at least 200 XAF');
      return;
    }

    final verified = await PinPrompt.show(context);
    if (!mounted || !verified) return;

    setState(() => _submitting = true);
    try {
      final description = _descriptionController.text.trim();
      await MerchantRepository.instance.collectSoftpayPayment(
        customerPhone: phone,
        amount: amount,
        description: description.isEmpty ? null : description,
      );
      if (!mounted) return;
      _phoneController.clear();
      _amountController.clear();
      _descriptionController.clear();
      AppFeedback.toast(context, "Payment prompt sent to the customer's phone");
    } catch (e) {
      if (!mounted) return;
      AppFeedback.toast(context, 'Could not send payment prompt: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
        title: Text('Collect Payment',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassInfoCard(
                  icon: Icons.info_outline_rounded,
                  title: 'MTN MoMo only',
                  subtitle: 'This sends a payment prompt straight to an MTN '
                      'MoMo number. For Orange Money or other methods, use '
                      'a Payment Link or your QR Payment Page instead.',
                ),
                const SizedBox(height: 18),
                GlassSurface(
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.12,
                  blur: 14,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _Field(
                        label: "Customer's MTN number",
                        hint: 'e.g. 6XXXXXXXX',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      _Field(
                        label: 'Amount',
                        hint: '0.00',
                        controller: _amountController,
                        prefix: 'XAF',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _Field(
                        label: 'Description',
                        hint: 'Optional — what is this for?',
                        controller: _descriptionController,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 56,
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
                        : const Text('Send payment prompt'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The customer approves or declines on their own phone. '
                  "You'll see the transaction update in Activity once they respond.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                  ),
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
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
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
          ),
          decoration: InputDecoration(
            prefixText: prefix == null ? null : '$prefix ',
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: context.cardMutedColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.hairlineColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.hairlineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
