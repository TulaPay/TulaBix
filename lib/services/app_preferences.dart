import 'package:flutter/material.dart';
import 'package:tulapay/services/merchant_repository.dart';

/// App-level preferences that must drive `MaterialApp` (theme mode + locale).
/// Backed by the `merchant_preferences` row; held here as [ValueNotifier]s so
/// `main.dart` can rebuild `MaterialApp` when they change.
///
/// Language currently only switches the Material widget locale + intl
/// number/date formatting — app copy is not translated yet.
class AppPreferences {
  AppPreferences._();
  static final AppPreferences instance = AppPreferences._();

  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.system);
  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static const supportedLocales = [Locale('en'), Locale('fr')];

  /// A single Listenable that fires when either notifier changes — convenient
  /// for a top-level `ListenableBuilder`.
  Listenable get listenable => Listenable.merge([themeMode, locale]);

  bool _hydrated = false;

  /// Load from Supabase after sign-in. Safe to call more than once.
  Future<void> hydrate() async {
    if (_hydrated) return;
    try {
      final prefs = await MerchantRepository.instance.preferences();
      themeMode.value = prefs.themeMode;
      locale.value = prefs.locale;
      _hydrated = true;
    } catch (_) {
      // Leave defaults; a merchant may not have a preferences row / merchant
      // profile yet. hydrate() will be retried on next app entry.
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _persist({'theme': _themeToken(mode)});
  }

  Future<void> setLocale(Locale value) async {
    locale.value = value;
    await _persist({'language': value.languageCode});
  }

  /// Reset to defaults on sign-out.
  void reset() {
    themeMode.value = ThemeMode.system;
    locale.value = const Locale('en');
    _hydrated = false;
  }

  Future<void> _persist(Map<String, dynamic> patch) async {
    try {
      await MerchantRepository.instance.savePreferences(patch);
    } catch (_) {
      // Non-fatal — the in-memory value still applies for this session.
    }
  }

  static String _themeToken(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}
