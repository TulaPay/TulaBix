import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/widgets/glass_page_shell.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPageShell(
      title: 'Favorites',
      subtitle: 'Pin your most used settings and screens here.',
      icon: Icons.favorite_outline_rounded,
      actionLabel: 'Add favorite',
      onAction: () {},
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(
                Icons.favorite_outline,
                size: 64,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: 16),
              Text(
                "No favorites yet",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
