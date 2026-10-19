import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/business_information_screen.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class KycOnboarding extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String country;

  const KycOnboarding({
    super.key,
    required this.businessName,
    required this.businessType,
    required this.country,
  });

  @override
  State<KycOnboarding> createState() => _KycOnboardingState();
}

class _KycOnboardingState extends State<KycOnboarding> {
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
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: context.primaryTintColor,
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.12,
                                    child: Image.asset(
                                      "assets/images/businessman.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                    Icons.verified_user_rounded,
                                    size: 56,
                                    color: cs.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Verify your business in under 5 minutes",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.7,
                              color: cs.onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Join thousands of merchants growing their business with TulaPay's secure platform.",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.66),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildRequirementItem(
                            context,
                            icon: Icons.business_outlined,
                            title: "Business details",
                            subtitle: "Basic information about your company",
                          ),
                          _buildRequirementItem(
                            context,
                            icon: Icons.badge_outlined,
                            title: "ID verification",
                            subtitle: "A valid government-issued ID card",
                          ),
                          _buildRequirementItem(
                            context,
                            icon: Icons.account_balance_outlined,
                            title: "Settlement account",
                            subtitle: "Where you will receive your payments",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: context.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Data encrypted and strictly confidential",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusinessInformationScreen(
                              businessName: widget.businessName,
                              businessType: widget.businessType,
                              country: widget.country,
                            ),
                          ),
                        );
                      },
                      child: const Text("Get Started"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.hairlineColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.caption(color: context.textSecondary),
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
