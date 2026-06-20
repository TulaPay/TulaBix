import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/business_details.dart';

class KycOnboarding extends StatefulWidget {
  const KycOnboarding({super.key});

  @override
  State<KycOnboarding> createState() => _KycOnboardingState();
}

class _KycOnboardingState extends State<KycOnboarding> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section with Image
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.3,
                              child: Center(
                                child: Image.asset(
                                  "assets/images/businessman.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verify your business in under 5 minutes",
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Join thousands of merchants growing their business with TulaPay's secure platform.",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Requirements List
                        _buildRequirementItem(
                          context,
                          icon: Icons.business_outlined,
                          title: "Business Details",
                          subtitle: "Basic information about your company",
                        ),
                        _buildRequirementItem(
                          context,
                          icon: Icons.badge_outlined,
                          title: "ID Verification",
                          subtitle: "A valid government-issued ID card",
                        ),
                        _buildRequirementItem(
                          context,
                          icon: Icons.account_balance_outlined,
                          title: "Settlement Account",
                          subtitle: "Where you will receive your payments",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Footer
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BusinessDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Data encrypted and strictly confidential",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
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
