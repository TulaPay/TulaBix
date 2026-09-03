import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the reference-derived visual system.
///
/// The blue identity is unchanged: [AppColors.primary] `#0000FF` and
/// [AppColors.secondary] `#4D73FF` remain the accent / CTA / active-state
/// colors. Everything added here is a tint, shade, or neutral used only for
/// backgrounds, cards, hairlines, tracks, and the gradient hero.

abstract class AppColors {
  // ── Brand (unchanged) ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0000FF); // Pure Blue — brand accent
  static const Color secondary = Color(0xFF4D73FF); // Vibrant medium blue
  static const Color tertiary = Color(0xFFFF5252); // Red — badges / alerts
  static const Color neutral = Color(0xFF758296); // Gray-blue — captions

  // ── Semantic (financial state only) ───────────────────────────────────────
  // Reserved for money in/out, gains/losses, and alert severity — never for
  // decoration. Readable on both light and dark surfaces as-is.
  static const Color positive = Color(0xFF10B981); // money in / gain
  static const Color negative = Color(0xFFFF5252); // money out / loss (== tertiary)
  static const Color warning = Color(0xFFF5A524); // attention, not an error

  // ── Blue tonal ramp (surfaces only) ────────────────────────────────────────
  static const Color primaryShade = Color(0xFF0000CC); // pressed / hover
  static const Color primaryTint = Color(0xFFECECFF); // chip / track fill (light)
  static const Color heroGradientStart = Color(0xFF4D73FF);
  static const Color heroGradientEnd = Color(0xFF0000FF);

  // ── Light surfaces ─────────────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF0F4FF); // pale blue backdrop
  static const Color cardLight = Colors.white;
  static const Color cardMutedLight = Color(0xFFF5F7FF); // neutral inner card
  static const Color trackLight = Color(0xFFE8ECF9); // segmented-control track
  static const Color hairlineLight = Color(0xFFE4E8F4);
  static const Color textPrimaryLight = Color(0xFF0A102D);
  static const Color textSecondaryLight = Color(0xFF6A7385);
  static const Color textTertiaryLight = Color(0xFFA2AAB9);
  static const Color inkPillLight = Color(0xFF0A102D); // dark pill button

  // ── Dark surfaces ──────────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF05081A); // deep indigo black
  static const Color cardDark = Color(0xFF141A3A);
  static const Color cardMutedDark = Color(0xFF10152F);
  static const Color trackDark = Color(0xFF1E254A);
  static const Color hairlineDark = Color(0xFF2A3157);
  static const Color textPrimaryDark = Color(0xFFF2F4FF);
  static const Color textSecondaryDark = Color(0xFF98A2C4);
  static const Color textTertiaryDark = Color(0xFF6D77A0);
  static const Color primaryDarkAccent = Color(0xFF80A0FF);
  static const Color inkPillDark = Color(0xFFF2F4FF); // light pill in dark mode

  // Kept for backwards compatibility with any older references.
  static const Color surfaceLight = cardLight;
  static const Color surfaceDark = cardDark;
  static const Color textDark = textPrimaryLight;
}

/// 4-based spacing scale. Use these instead of loose magic numbers.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double huge = 32;
  static const double section = 40;
}

/// Corner-radius scale.
abstract class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 28;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Soft, low-contrast elevation. The references use one gentle drop or none.
abstract class AppShadows {
  static List<BoxShadow> card(Brightness b) => b == Brightness.dark
      ? const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x0F0A102D),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ];

  static List<BoxShadow> floating(Color accent) => [
        BoxShadow(
          color: accent.withValues(alpha: 0.22),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}

/// Typography helpers built on Plus Jakarta Sans. Pass a [color]; if omitted the
/// caller is expected to sit inside a `DefaultTextStyle` / themed `Text`.
abstract class AppText {
  static TextStyle hero({double size = 40, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.05,
        color: color,
      );

  static TextStyle screenTitle({double size = 28, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.1,
        color: color,
      );

  static TextStyle sectionTitle({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle cardTitle({double size = 15, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle microLabel({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color,
      );

  static TextStyle body({double size = 14, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  static TextStyle pillLabel({Color? color}) => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
      );
}

/// Convenience accessors for the theme-aware neutral tokens.
extension AppThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor =>
      isDark ? AppColors.cardDark : AppColors.cardLight;
  Color get cardMutedColor =>
      isDark ? AppColors.cardMutedDark : AppColors.cardMutedLight;
  Color get trackColor =>
      isDark ? AppColors.trackDark : AppColors.trackLight;
  Color get hairlineColor =>
      isDark ? AppColors.hairlineDark : AppColors.hairlineLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textTertiary =>
      isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
  Color get inkPillColor =>
      isDark ? AppColors.inkPillDark : AppColors.inkPillLight;
  // Light mode: dark pill -> white label. Dark mode: light pill -> ink label.
  Color get onInkPillColor => isDark ? AppColors.bgDark : Colors.white;
}
