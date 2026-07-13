import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
          style: GoogleFonts.plusJakartaSans(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Text(
            "Your privacy is important to us. It is TulaBix's policy to respect your privacy regarding any information we may collect from you across our website, and other sites we own and operate...\n\n[Full Privacy Policy Text Here]",
            style: GoogleFonts.plusJakartaSans(
              color: cs.onSurfaceVariant,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
