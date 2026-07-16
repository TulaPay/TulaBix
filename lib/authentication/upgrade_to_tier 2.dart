import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class UpgradeToTier extends StatefulWidget {
  const UpgradeToTier({super.key});

  @override
  State<UpgradeToTier> createState() => _UpgradeToTierState();
}

class _UpgradeToTierState extends State<UpgradeToTier> {
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
          icon: Icon(Icons.arrow_back_ios_new, color: cs.onSurface),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cs.primary.withValues(alpha: 0.26),
                                  cs.secondary.withValues(alpha: 0.14),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "Premium Tier",
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
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCapabilityItem(
                      context,
                      icon: Icons.trending_up_rounded,
                      title: "Higher Transaction Limits",
                      description:
                          "Send and receive up to 5,000,000 XAF daily without restrictions.",
                    ),
                    _buildCapabilityItem(
                      context,
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Multiple Business Wallets",
                      description:
                          "Create and manage revenue streams for different branches.",
                    ),
                    _buildCapabilityItem(
                      context,
                      icon: Icons.description_outlined,
                      title: "Financial Statements",
                      description:
                          "Generate professional monthly reports for tax and auditing.",
                    ),
                    _buildCapabilityItem(
                      context,
                      icon: Icons.verified_user_outlined,
                      title: "Priority Verification",
                      description: "Your support requests and payments handled first.",
                    ),
                    const SizedBox(height: 20),
                    GlassSurface(
                      borderRadius: BorderRadius.circular(24),
                      opacity: 0.12,
                      blur: 12,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Request Upgrade"),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Standard review takes 12-24 hours",
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: 0.56),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildCapabilityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(20),
        opacity: 0.12,
        blur: 12,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.22),
                    cs.primary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: cs.primary, size: 26),
            ),
            const SizedBox(width: 16),
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
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withValues(alpha: 0.66),
                      height: 1.4,
                    ),
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
