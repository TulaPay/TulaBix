import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/sign_up.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode = 'en'; // Default to English

  // Localized strings map for English and French
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
      'info':
          'Vous pourrez modifier votre langue plus tard dans les paramètres.',
    },
  };

  String _t(String key) => _localizedValues[_selectedLanguageCode]![key]!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('title')),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _t('header'),
                style: GoogleFonts.inter(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _t('subtitle'),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Language Selection Tiles
              LanguageTile(
                title: _t('english'),
                subtitle: "English",
                isSelected: _selectedLanguageCode == 'en',
                onTap: () => setState(() => _selectedLanguageCode = 'en'),
                flag: "🇺🇸",
              ),
              const SizedBox(height: 16),
              LanguageTile(
                title: _t('french'),
                subtitle: "Français",
                isSelected: _selectedLanguageCode == 'fr',
                onTap: () => setState(() => _selectedLanguageCode = 'fr'),
                flag: "🇫🇷",
              ),

              const Spacer(),

              // Information Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _t('info'),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              ElevatedButton(
                onPressed: () {
                  // TODO: Save preference and navigate to onboarding or home
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignUp()),
                  );
                },
                child: Text(_t('continue')),
              ),
              const SizedBox(height: 24),
            ],
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
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? colorScheme.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary)
            else
              Icon(
                Icons.circle_outlined,
                color: colorScheme.outline.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
