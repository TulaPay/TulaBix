import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/themes/app_tokens.dart';

export 'package:tulapay/themes/app_tokens.dart';

/// Corporate Redesign Theme Specification.
/// Warm pale Light mode, Deep Corporate Navy Dark mode (`#0B1020`), `#262D49` hairlines,
/// `#2F5AF2` Corporate Blue accent, Plus Jakarta Sans global typography.
class AppTheme {
  AppTheme._();

  static final RoundedRectangleBorder _btnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  static ButtonStyle darkPillStyle(BuildContext context) {
    final ink = context.inkPillColor;
    return TextButton.styleFrom(
      backgroundColor: ink,
      foregroundColor: context.onInkPillColor,
      textStyle: AppText.pillLabel(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm + 2,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      minimumSize: const Size(0, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // ── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme => _build(
    brightness: Brightness.light,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: Color(0xFF1E3A8A),
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE4E9F9),
      onSecondaryContainer: Color(0xFF10162B),
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFDAD6),
      onTertiaryContainer: Color(0xFF410002),
      error: AppColors.negative,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: AppColors.bgLight,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF3F5FA),
      surfaceContainer: AppColors.bgLight,
      surfaceContainerHigh: Color(0xFFE4E9F9),
      surfaceContainerHighest: Color(0xFFDCE1EA),
      surfaceDim: AppColors.bgLight,
      surfaceBright: Colors.white,
      outline: Color(0xFFB8C0D4),
      outlineVariant: AppColors.hairlineLight,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.textPrimaryLight,
      onInverseSurface: Color(0xFFF3F5FA),
      inversePrimary: AppColors.secondary,
    ),
    scaffoldBg: AppColors.bgLight,
    card: AppColors.cardLight,
    track: AppColors.trackLight,
    hairline: AppColors.hairlineLight,
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme => _build(
    brightness: Brightness.dark,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDarkAccent,
      onPrimary: AppColors.bgDark,
      primaryContainer: Color(0xFF1B2142),
      onPrimaryContainer: Color(0xFFE4E9F9),
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF1B2142),
      onSecondaryContainer: Color(0xFFE4E9F9),
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF5C2B2E),
      onTertiaryContainer: Color(0xFFFF8A80),
      error: AppColors.negative,
      onError: Colors.white,
      errorContainer: Color(0xFF5C2B2E),
      onErrorContainer: Color(0xFFFF8A80),
      surface: AppColors.bgDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      surfaceContainerLowest: Color(0xFF0B0F26),
      surfaceContainerLow: Color(0xFF141A33),
      surfaceContainer: AppColors.bgDark,
      surfaceContainerHigh: Color(0xFF1B2142),
      surfaceContainerHighest: Color(0xFF262D49),
      surfaceDim: AppColors.bgDark,
      surfaceBright: Color(0xFF1B2142),
      outline: Color(0xFF4A5480),
      outlineVariant: AppColors.hairlineDark,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFE4E9F9),
      onInverseSurface: AppColors.cardDark,
      inversePrimary: AppColors.primaryShade,
    ),
    scaffoldBg: AppColors.bgDark,
    card: AppColors.cardDark,
    track: AppColors.trackDark,
    hairline: AppColors.hairlineDark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBg,
    required Color card,
    required Color track,
    required Color hairline,
  }) {
    final baseText = GoogleFonts.plusJakartaSansTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      dividerColor: hairline,
      splashFactory: InkSparkle.splashFactory,

      textTheme: baseText.copyWith(
        headlineLarge: AppText.hero(size: 34, color: scheme.onSurface),
        headlineMedium: AppText.screenTitle(size: 28, color: scheme.onSurface),
        headlineSmall: AppText.screenTitle(size: 22, color: scheme.onSurface),
        titleLarge: AppText.sectionTitle(color: scheme.onSurface),
        titleMedium: AppText.cardTitle(size: 15, color: scheme.onSurface),
        titleSmall: AppText.cardTitle(size: 13, color: scheme.onSurface),
        bodyLarge: AppText.body(size: 15, color: scheme.onSurface),
        bodyMedium: AppText.body(size: 14, color: scheme.onSurfaceVariant),
        bodySmall: AppText.caption(color: scheme.onSurfaceVariant),
        labelLarge: AppText.pillLabel(color: scheme.onSurface),
        labelMedium: AppText.microLabel(color: scheme.onSurfaceVariant),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.screenTitle(size: 20, color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 24),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: hairline, width: 1),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.4),
          disabledForegroundColor: scheme.onPrimary.withValues(alpha: 0.8),
          minimumSize: const Size.fromHeight(52),
          textStyle: AppText.pillLabel(),
          elevation: 0,
          shape: _btnShape,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppText.pillLabel(),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: _btnShape,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary, width: 1),
          minimumSize: const Size.fromHeight(52),
          textStyle: AppText.pillLabel(),
          shape: _btnShape,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: AppText.pillLabel(),
          shape: _btnShape,
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? (brightness == Brightness.light ? Colors.white : card)
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
          textStyle: WidgetStatePropertyAll(AppText.pillLabel()),
          side: const WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? AppColors.cardDark
            : const Color(0xFFF1F3F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: AppText.body(color: scheme.onSurfaceVariant),
        labelStyle: AppText.body(color: scheme.onSurfaceVariant),
        floatingLabelStyle: AppText.caption(color: scheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: track,
        selectedColor: brightness == Brightness.dark
            ? AppColors.trackDark
            : AppColors.primaryTint,
        side: BorderSide.none,
        labelStyle: AppText.caption(color: scheme.onSurfaceVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : track,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
        titleTextStyle: AppText.sectionTitle(color: scheme.onSurface),
        contentTextStyle: AppText.body(color: scheme.onSurfaceVariant),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppText.body(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedLabelStyle: AppText.caption(),
        unselectedLabelStyle: AppText.caption(),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: AppText.cardTitle(color: scheme.onSurface),
        subtitleTextStyle: AppText.caption(color: scheme.onSurfaceVariant),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle: AppText.pillLabel(),
        unselectedLabelStyle: AppText.pillLabel(),
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
      ),

      iconTheme: IconThemeData(color: scheme.onSurface),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    );
  }
}
