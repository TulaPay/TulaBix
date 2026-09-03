import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/screens/Navigation_bar.dart';
import 'package:tulapay/services/merchant_service.dart';
import 'package:tulapay/widgets/glass_effects.dart';

/// Final onboarding step: where settlement payouts should land. Fulfils the
/// third requirement KycOnboarding's copy already promises ("Settlement
/// Account") but that no screen previously collected.
class SettlementAccountScreen extends StatefulWidget {
  final String merchantId;

  const SettlementAccountScreen({super.key, required this.merchantId});

  @override
  State<SettlementAccountScreen> createState() => _SettlementAccountScreenState();
}

class _SettlementAccountScreenState extends State<SettlementAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String _provider = 'mtn_momo';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleFinish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await MerchantService.instance.submitSettlementAccount(
        merchantId: widget.merchantId,
        provider: _provider,
        phoneNumber: _phoneController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Navigation_Bar()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Settlement Account",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Where should we send your payouts?",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.66),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildProviderOption(
                                id: 'mtn_momo',
                                label: 'MTN MoMo',
                                icon: Icons.phone_android_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildProviderOption(
                                id: 'orange_money',
                                label: 'Orange Money',
                                icon: Icons.phone_android_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 4),
                          child: Text(
                            "Mobile Money Number",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: "+237 6XX XXX XXX",
                            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                          ),
                          validator: (val) => (val == null || val.length < 8)
                              ? "Enter a valid mobile money number"
                              : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleFinish,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Finish"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderOption({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _provider == id;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => setState(() => _provider = id),
      borderRadius: BorderRadius.circular(18),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(18),
        opacity: isSelected ? 0.18 : 0.12,
        blur: 12,
        border: Border.all(
          color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.16),
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.6)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
