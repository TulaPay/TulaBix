import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class GrowthGoalsScreen extends StatelessWidget {
  const GrowthGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Growth Goals",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track merchant growth',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitor revenue, retention, and customer acquisition from the same dashboard.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _goalCard(context, "Increase Revenue", 0.7, "70% achieved"),
          const SizedBox(height: 12),
          _goalCard(context, "Customer Acquisition", 0.4, "40% achieved"),
          const SizedBox(height: 12),
          _goalCard(context, "Repeat Orders", 0.55, "55% achieved"),
        ],
      ),
    );
  }

  Widget _goalCard(
    BuildContext context,
    String title,
    double progress,
    String label,
  ) {
    final cs = Theme.of(context).colorScheme;
    return GlassSurface(
      borderRadius: BorderRadius.circular(24),
      opacity: 0.12,
      blur: 12,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: cs.outlineVariant.withValues(alpha: 0.14),
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
