import 'package:flutter/material.dart';
import 'package:tulapay/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';
import 'package:tulapay/l10n/l10n_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.privacyPolicy,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        children: [
          GlassSurface(
            child: Text(
              context.l10n.yourPrivacyMattersTulabixLimited,
              style: GoogleFonts.plusJakartaSans(
                color: context.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GlassInfoCard(
            icon: Icons.lock_outline_rounded,
            title: context.l10n.dataProtection,
            subtitle:
                context.l10n.accessIsLimitedToThe,
          ),
          GlassInfoCard(
            icon: Icons.analytics_outlined,
            title: context.l10n.usageData,
            subtitle:
                context.l10n.usedToImproveReliabilityFraud,
          ),
          GlassInfoCard(
            icon: Icons.contact_support_outlined,
            title: context.l10n.contact,
            subtitle:
                context.l10n.questionsAboutPrivacyCanBe,
          ),
        ],
      ),
    );
  }
}
