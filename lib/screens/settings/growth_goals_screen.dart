import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GrowthGoalsScreen extends StatelessWidget {
  const GrowthGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Growth Goals",
          style: GoogleFonts.plusJakartaSans(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  _buildGoalItem(context, "Increase Revenue", 0.7, "70% achieved"),
                  const SizedBox(height: 20),
                  _buildGoalItem(context, "Customer Acquisition", 0.4, "40% achieved"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, String title, double progress, String label) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: cs.outlineVariant.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: cs.onSurfaceVariant)),
      ],
    );
  }
}
