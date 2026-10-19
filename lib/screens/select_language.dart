import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/authentication/sign_up.dart';
import 'package:tulapay/services/app_preferences.dart';
import 'package:tulapay/widgets/glass_effects.dart';
import 'package:tulapay/themes/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  /// When true the screen is opened from Settings: the choice is persisted via
  /// [AppPreferences] and the screen pops. When false (onboarding) it pushes
  /// on to Sign Up as before.
  final bool settingsMode;

  const LanguageScreen({super.key, this.settingsMode = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguageCode = widget.settingsMode
      ? AppPreferences.instance.locale.value.languageCode
      : 'en';

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Select Language',
      'header': 'Choose your Language',
      'subtitle': 'Select your preferred language for TulaPay',
      'continue': 'Continue',
      'save': 'Save',
      'english': 'English',
      'french': 'French',
      'info': 'You can change your language preference later in settings.',
    },
    'fr': {
      'title': 'Choisir la langue',
      'header': 'Choisissez votre langue',
      'subtitle': 'Sélectionnez votre langue préférée pour TulaPay',
      'continue': 'Continuer',
      'save': 'Enregistrer',
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: context.isDark
                                    ? AppColors.trackDark
                                    : AppColors.primaryTint,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.language_rounded,
                                size: 40,
                                color: cs.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _t('header'),
                            style: AppText.screenTitle(
                                size: 24, color: cs.onSurface),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _t('subtitle'),
                            style: AppText.body(color: context.textSecondary),
                          ),
                          const SizedBox(height: 24),
                          LanguageTile(
                            title: _t('english'),
                            subtitle: 'English',
                            isSelected: _selectedLanguageCode == 'en',
                            onTap: () =>
                                setState(() => _selectedLanguageCode = 'en'),
                            flag: '🇺🇸',
                          ),
                          const SizedBox(height: 12),
                          LanguageTile(
                            title: _t('french'),
                            subtitle: 'Français',
                            isSelected: _selectedLanguageCode == 'fr',
                            onTap: () =>
                                setState(() => _selectedLanguageCode = 'fr'),
                            flag: '🇫🇷',
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: context.isDark
                                  ? AppColors.trackDark
                                  : AppColors.primaryTint,
                              borderRadius: AppRadius.xsAll,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 18, color: context.textSecondary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _t('info'),
                                    style: AppText.caption(
                                        color: context.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.settingsMode) {
                          await AppPreferences.instance
                              .setLocale(Locale(_selectedLanguageCode));
                          if (context.mounted) Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUp()),
                          );
                        }
                      },
                      child: Text(
                          widget.settingsMode ? _t('save') : _t('continue')),
                    ),
                  ),
                ],
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
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isSelected ? cs.primary : context.hairlineColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: context.isDark
                    ? AppColors.trackDark
                    : AppColors.primaryTint,
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
                      fontWeight: FontWeight.w700,
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
              Icon(Icons.radio_button_checked, size: 18, color: cs.primary)
            else
              Icon(
                Icons.radio_button_unchecked,
                size: 18,
                color: context.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
