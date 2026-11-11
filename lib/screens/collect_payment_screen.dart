import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/format.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/services/push_notification_service.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/pin_prompt.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

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
      AppFeedback.toast(context, context.l10n.enterTheCustomerSMtn);
      return;
    }
    if (amount == null || amount < 200) {
      AppFeedback.toast(context, context.l10n.enterAnAmountOfAt);
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
      AppFeedback.toast(context, context.l10n.paymentPromptSentToThe);
      PushNotificationService.instance.showNotification(
        title: context.l10n.paymentPromptSent,
        body: context.l10n.momoPromptSent(money(amount), phone),
      );
    } catch (e) {
      if (!mounted) return;
      AppFeedback.toast(context, context.l10n.couldNotSendPrompt('$e'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(context.l10n.collectPayment,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                InfoNote(
                  title: context.l10n.mtnMomoOnly,
                  message: context.l10n.thisSendsAPaymentPrompt2,
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.paymentDetails,
                  style: AppText.microLabel(color: context.textTertiary)
                      .copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 14),
                GlassSurface(
                  child: Column(
                    children: [
                      _Field(
                        label: context.l10n.customerSMtnNumber,
                        hint: context.l10n.eG6xxxxxxxx,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: context.l10n.amount,
                        hint: '0.00',
                        controller: _amountController,
                        prefix: 'XAF',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: context.l10n.description,
                        hint: context.l10n.optionalWhatIsThisFor,
                        controller: _descriptionController,
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
                        : Text(context.l10n.sendPaymentPrompt),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.theCustomerApprovesOrDeclines2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.5,
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
