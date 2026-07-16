import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Profile",
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
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: cs.surfaceContainerHigh,
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?u=jacob',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Update merchant identity',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassSurface(
            borderRadius: BorderRadius.circular(28),
            opacity: 0.12,
            blur: 14,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field('Full name'),
                const SizedBox(height: 14),
                _field('Email'),
                const SizedBox(height: 14),
                _field('Phone number'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Save changes",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
