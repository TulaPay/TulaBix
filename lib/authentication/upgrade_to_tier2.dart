import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/services/merchant_repository.dart';
import 'package:tulapay/utils/app_feedback.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class UpgradeToTier extends StatefulWidget {
  const UpgradeToTier({super.key});

  @override
  State<UpgradeToTier> createState() => _UpgradeToTierState();
}

class _UpgradeToTierState extends State<UpgradeToTier> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await MerchantRepository.instance.requestTier2Upgrade();
      if (!mounted) return;
      AppFeedback.toast(context, 'Upgrade requested — we\'ll be in touch');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        AppFeedback.toast(context, 'Could not submit — try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upgrade Account",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassSurface(
                            borderRadius: BorderRadius.circular(12),
                            opacity: 0.16,
                            blur: 18,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.pill,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Color(0xFFF5B83D),
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Premium tier",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "Upgrade to Tier 2",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: cs.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Unlock professional financial tools and expand your business limits with TulaPay.",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.66),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "NEW CAPABILITIES",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                              color: context.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildCapabilityItem(
                            context,
                            icon: Icons.trending_up_rounded,
                            title: "Higher transaction limits",
                            description:
                                "Send and receive up to 5,000,000 XAF daily without restrictions.",
                          ),
                          _buildCapabilityItem(
                            context,
                            icon: Icons.account_balance_wallet_outlined,
                            title: "Multiple business wallets",
                            description:
                                "Create and manage revenue streams for different branches.",
                          ),
                          _buildCapabilityItem(
                            context,
                            icon: Icons.description_outlined,
                            title: "Financial statements",
                            description:
                                "Generate professional monthly reports for tax and auditing.",
                          ),
                          _buildCapabilityItem(
                            context,
                            icon: Icons.verified_user_outlined,
                            title: "Priority verification",
                            description:
                                "Your support requests and payments handled first.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Request upgrade"),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Standard review takes 12–24 hours",
                      style: AppText.caption(color: context.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryTintColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.cardTitle(size: 15, color: cs.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppText.caption(
                      color: context.textSecondary,
                    ).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
