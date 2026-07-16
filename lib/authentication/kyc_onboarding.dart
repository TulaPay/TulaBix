import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/business_details.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class KycOnboarding extends StatefulWidget {
  const KycOnboarding({super.key});

  @override
  State<KycOnboarding> createState() => _KycOnboardingState();
}

class _KycOnboardingState extends State<KycOnboarding> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: cs.onSurface),
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
                      borderRadius: BorderRadius.circular(28),
                      opacity: 0.16,
                      blur: 18,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.24,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  cs.primary.withValues(alpha: 0.28),
                                  cs.secondary.withValues(alpha: 0.14),
                                ],
                              ),
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
                                    size: 72,
                                    color: cs.onPrimary,
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
                              fontWeight: FontWeight.w800,
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
                            title: "Business Details",
                            subtitle: "Basic information about your company",
                          ),
                          const SizedBox(height: 14),
                          _buildRequirementItem(
                            context,
                            icon: Icons.badge_outlined,
                            title: "ID Verification",
                            subtitle: "A valid government-issued ID card",
                          ),
                          const SizedBox(height: 14),
                          _buildRequirementItem(
                            context,
                            icon: Icons.account_balance_outlined,
                            title: "Settlement Account",
                            subtitle: "Where you will receive your payments",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    GlassSurface(
                      borderRadius: BorderRadius.circular(24),
                      opacity: 0.12,
                      blur: 12,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 16, color: cs.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Data encrypted and strictly confidential",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.56),
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
                            builder: (_) => const BusinessDetails(),
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
    return GlassSurface(
      borderRadius: BorderRadius.circular(20),
      opacity: 0.12,
      blur: 12,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.24),
                  cs.primary.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: cs.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: 0.56),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
