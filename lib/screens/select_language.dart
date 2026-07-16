import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/sign_up.dart';
import 'package:tulapay/widgets/glass_effects.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode = 'en';

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Select Language',
      'header': 'Choose your Language',
      'subtitle': 'Select your preferred language for TulaPay',
      'continue': 'Continue',
      'english': 'English',
      'french': 'French',
      'info': 'You can change your language preference later in settings.',
    },
    'fr': {
      'title': 'Choisir la langue',
      'header': 'Choisissez votre langue',
      'subtitle': 'Sélectionnez votre langue préférée pour TulaPay',
      'continue': 'Continuer',
      'english': 'Anglais',
      'french': 'Français',
      'info': 'Vous pourrez modifier votre langue plus tard dans les paramètres.',
    },
  };

  String _t(String key) => _localizedValues[_selectedLanguageCode]![key]!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_t('title')),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        centerTitle: true,
      ),
      body: AppBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: GlassSurface(
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.16,
                  blur: 18,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                cs.primary.withValues(alpha: 0.28),
                                cs.secondary.withValues(alpha: 0.12),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            size: 64,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _t('header'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _t('subtitle'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: cs.onSurface.withValues(alpha: 0.72),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LanguageTile(
                        title: _t('english'),
                        subtitle: 'English',
                        isSelected: _selectedLanguageCode == 'en',
                        onTap: () => setState(() => _selectedLanguageCode = 'en'),
                        flag: '🇺🇸',
                      ),
                      const SizedBox(height: 14),
                      LanguageTile(
                        title: _t('french'),
                        subtitle: 'Français',
                        isSelected: _selectedLanguageCode == 'fr',
                        onTap: () => setState(() => _selectedLanguageCode = 'fr'),
                        flag: '🇫🇷',
                      ),
                      const SizedBox(height: 20),
                      GlassSurface(
                        borderRadius: BorderRadius.circular(20),
                        opacity: 0.12,
                        blur: 12,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _t('info'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: cs.onSurface.withValues(alpha: 0.82),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUp()),
                          );
                        },
                        child: Text(_t('continue')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.18),
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.18),
                    cs.secondary.withValues(alpha: 0.08),
                  ],
                )
              : null,
          color: isSelected ? null : cs.surface.withValues(alpha: 0.55),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: cs.primary.withValues(alpha: 0.10),
              ),
              child: Center(
                child: Text(flag, style: const TextStyle(fontSize: 24)),
              ),
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
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: cs.onSurface.withValues(alpha: 0.66),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: cs.primary)
            else
              Icon(
                Icons.circle_outlined,
                color: cs.outline.withValues(alpha: 0.45),
              ),
          ],
        ),
      ),
    );
  }
}
