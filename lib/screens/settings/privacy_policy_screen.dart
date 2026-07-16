import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          GlassSurface(
            borderRadius: BorderRadius.circular(28),
            opacity: 0.14,
            blur: 16,
            padding: const EdgeInsets.all(20),
            child: Text(
              "Your privacy matters. Tulabix Limited only collects the data needed to process payments, support merchants, and keep the platform secure. We do not sell merchant data.",
              style: GoogleFonts.plusJakartaSans(
                color: cs.onSurfaceVariant,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GlassInfoCard(
            icon: Icons.lock_outline_rounded,
            title: 'Data protection',
            subtitle:
                'Access is limited to the features needed for your merchant account.',
          ),
          const SizedBox(height: 12),
          GlassInfoCard(
            icon: Icons.analytics_outlined,
            title: 'Usage data',
            subtitle:
                'Used to improve reliability, fraud prevention, and support.',
          ),
          const SizedBox(height: 12),
          GlassInfoCard(
            icon: Icons.contact_support_outlined,
            title: 'Contact',
            subtitle:
                'Questions about privacy can be routed to support from the Help Center.',
          ),
        ],
      ),
    );
  }
}
