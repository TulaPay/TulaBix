import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/business_details.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class VerificationInProgressPage extends StatefulWidget {
  const VerificationInProgressPage({super.key});

  @override
  State<VerificationInProgressPage> createState() =>
      _VerificationInProgressPageState();
}

class _VerificationInProgressPageState extends State<VerificationInProgressPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AppBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        children: [
                          GlassSurface(
                            borderRadius: BorderRadius.circular(28),
                            opacity: 0.16,
                            blur: 18,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      colors: [
                                        cs.primary.withValues(alpha: 0.22),
                                        cs.secondary.withValues(alpha: 0.12),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: cs.primary,
                                        child: const Icon(
                                          Icons.file_copy_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        "Verification in progress",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: cs.onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "We're reviewing your documents",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: cs.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Your business is currently in our queue. Our security team verifies all new merchants to ensure network safety and compliance.",
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: cs.onSurface.withValues(alpha: 0.66),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                            color: cs.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Estimated time: ",
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              color: cs.onSurface,
                                            ),
                                          ),
                                          Text(
                                            "24 hours",
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w800,
                                              color: cs.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                _buildInfoCard(
                                  context,
                                  icon: Icons.notifications_active_outlined,
                                  title: "Get Notified",
                                  description:
                                      "We'll send an SMS and push notifications once your account is active.",
                                ),
                                const SizedBox(height: 14),
                                _buildInfoCard(
                                  context,
                                  icon: Icons.verified_user_outlined,
                                  title: "Bank-Grade Security",
                                  description:
                                      "Your data is encrypted and handled according to CEMAC regulations.",
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassSurface(
                  borderRadius: BorderRadius.circular(24),
                  opacity: 0.12,
                  blur: 12,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BusinessDetails(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.domain_rounded),
                        label: const Text("Continue to KYB"),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.support_agent_rounded),
                        label: const Text("Contact Support"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GlassSurface(
      borderRadius: BorderRadius.circular(20),
      opacity: 0.12,
      blur: 12,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.22),
                  cs.primary.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: cs.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
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
    );
  }
}
