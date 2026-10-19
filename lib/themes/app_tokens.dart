import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for TulaBix Corporate Redesign visual system.
///
/// Style guide v1: Royal Blue [AppColors.primary] `#1E3A8A` drives CTAs, nav
/// and headers; Action Blue [AppColors.secondary] `#2F5AF2` is for links and
/// selection only. Content sits directly on the page background — grouping is
/// by eyebrow label, spacing and a 1px hairline, never a card or shadow.

abstract class AppColors {
  // ── Brand & Accent ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1E3A8A); // Royal Blue (light-mode CTA)
  static const Color secondary = Color(
    0xFF2F5AF2,
  ); // Action Blue — links / selection
  static const Color tertiary = Color(
    0xFFD64545,
  ); // Corporate Red — badges / alerts
  static const Color neutral = Color(0xFF6B7490); // Gray-blue — captions

  // ── Semantic (financial state only) ───────────────────────────────────────
  static const Color positive = Color(0xFF0E9F6E); // money in / gain
  static const Color negative = Color(0xFFD64545); // money out / loss (Red)
  static const Color warning = Color(0xFFC77C11); // attention / pending

  // ── Blue tonal ramp ────────────────────────────────────────────────────────
  static const Color primaryShade = Color(0xFF152C6B); // pressed / hover
  static const Color primaryTint = Color(0xFFE4E9F9); // chip / track fill
  static const Color heroGradientStart = Color(0xFF1E3A8A);
  static const Color heroGradientEnd = Color(0xFF1E3A8A);

  // ── Light surfaces ─────────────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF3F5FA); // page background
  static const Color cardLight = Colors.white;
  static const Color cardMutedLight = Color(
    0xFFE8ECFB,
  ); // inner card / tinted surface
  static const Color trackLight = Color(0xFFE4EAF8);
  static const Color hairlineLight = Color(0xFFDCE1EA);
  static const Color textPrimaryLight = Color(0xFF10162B);
  static const Color textSecondaryLight = Color(0xFF5B6472);
  static const Color textTertiaryLight = Color(0xFF8992A6);
  static const Color inkPillLight = Color(0xFF10162B); // dark pill button

  // ── Dark surfaces ──────────────────────────────────────────────────────────
  static const Color bgDark = Color(0xFF0B1020); // deep corporate navy black
  static const Color cardDark = Color(0xFF141A33); // corporate navy card
  static const Color cardMutedDark = Color(0xFF1B2142);
  static const Color trackDark = Color(0xFF1B2142);
  static const Color hairlineDark = Color(
    0xFF262D49,
  ); // sharp navy hairline border
  static const Color textPrimaryDark = Color(0xFFEEF1FA);
  static const Color textSecondaryDark = Color(0xFF9AA3BD);
  static const Color textTertiaryDark = Color(0xFF6B7490);
  static const Color primaryDarkAccent = Color(
    0xFF5D7FFF,
  ); // primary / links on dark only
  static const Color inkPillDark = Color(0xFFFFFFFF); // light pill in dark mode

  // Backwards compatibility.
  static const Color surfaceLight = cardLight;
  static const Color surfaceDark = cardDark;
  static const Color textDark = textPrimaryLight;
}

/// 4-based spacing scale.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double huge = 32;
  static const double section = 40;
  static const double major =
      56; // gap between major sections (replaces card edges)
}

/// Corner-radius scale.
abstract class AppRadius {
  // Style guide v1: 4 / 8 / 12 / pill. lg–xxl are kept as aliases of md so
  // existing call sites collapse onto the new scale.
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = md;
  static const double xl = md;
  static const double xxl = md;
  static const double pill = 999;

  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Elevation shadows matching corporate card specifications.
abstract class AppShadows {
  /// Elevation is retired — grouping comes from spacing and hairlines.
  static List<BoxShadow> card(Brightness b) => const [];

  static List<BoxShadow> floating(Color accent) => const [];
}

/// Gradient presets for the Corporate Redesign.
abstract class AppGradients {
  /// Balance card gradient — blue-tinted flat (matches redesign light card)
  static const LinearGradient balanceCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE4E9F9), Color(0xFFE4E9F9)],
  );

  /// Hero brand gradient — used on splash and primary CTAs
  static const LinearGradient heroBrand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1E3A8A)],
  );

  /// Positive glow gradient (money in)
  static const LinearGradient positiveGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E9F6E), Color(0xFF0E9F6E)],
  );
}

/// Animation duration and curve constants.
abstract class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration expressive = Duration(milliseconds: 350);
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve entranceCurve = Curves.easeOut;
}

/// Typography helpers built on Plus Jakarta Sans.
abstract class AppText {
  static TextStyle hero({double size = 40, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.05,
        color: color,
      );

  static TextStyle screenTitle({double size = 28, Color? color}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
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

/// Convenience accessors for theme-aware tokens.
extension AppThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor => isDark ? AppColors.cardDark : AppColors.cardLight;
  Color get cardMutedColor =>
      isDark ? AppColors.cardMutedDark : AppColors.cardMutedLight;
  Color get trackColor => isDark ? AppColors.trackDark : AppColors.trackLight;
  Color get hairlineColor =>
      isDark ? AppColors.hairlineDark : AppColors.hairlineLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textTertiary =>
      isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;
  Color get primaryTintColor =>
      isDark ? AppColors.trackDark : AppColors.primaryTint;
  Color get inputFillColor =>
      isDark ? AppColors.cardDark : const Color(0xFFF1F3F8);
  Color get inkPillColor =>
      isDark ? AppColors.inkPillDark : AppColors.inkPillLight;
  Color get onInkPillColor => isDark ? AppColors.bgDark : Colors.white;
}
