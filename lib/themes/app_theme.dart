import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulapay/themes/app_tokens.dart';

export 'package:tulapay/themes/app_tokens.dart';

/// App theme rebuilt around the reference design language:
/// pale page background, pure-white cards, generous radius, one soft shadow,
/// Plus Jakarta Sans wired in globally, and the blue brand accent kept intact.
class AppTheme {
  AppTheme._();

  // ── Shared button geometry ───────────────────────────────────────────────
  static final RoundedRectangleBorder _btnShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md));

  /// Near-black (light) / near-white (dark) pill button used for toolbar
  /// actions in the references (Skip / Export / Share).
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

  // ── Light ────────────────────────────────────────────────────────────────
  static ThemeData get lightTheme => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryTint,
          onPrimaryContainer: Color(0xFF00009C),
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFE1E8FF),
          onSecondaryContainer: Color(0xFF15245C),
          tertiary: AppColors.tertiary,
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFFFFDAD6),
          onTertiaryContainer: Color(0xFF410002),
          error: Color(0xFFBA1A1A),
          onError: Colors.white,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          surface: AppColors.cardLight,
          onSurface: AppColors.textPrimaryLight,
          onSurfaceVariant: AppColors.textSecondaryLight,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Color(0xFFF7F9FF),
          surfaceContainer: AppColors.bgLight,
          surfaceContainerHigh: Color(0xFFE9EEFC),
          surfaceContainerHighest: Color(0xFFE2E8F7),
          surfaceDim: Color(0xFFE0E4F0),
          surfaceBright: Colors.white,
          outline: Color(0xFFC3C9D9),
          outlineVariant: AppColors.hairlineLight,
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: AppColors.textPrimaryLight,
          onInverseSurface: Color(0xFFF2F3FB),
          inversePrimary: Color(0xFFBEC2FF),
        ),
        scaffoldBg: AppColors.bgLight,
        card: AppColors.cardLight,
        track: AppColors.trackLight,
        hairline: AppColors.hairlineLight,
      );

  // ── Dark ─────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.secondary,
          onPrimary: AppColors.bgDark,
          primaryContainer: Color(0xFF1E2A63),
          onPrimaryContainer: Color(0xFFDDE3FF),
          secondary: AppColors.primaryDarkAccent,
          onSecondary: AppColors.bgDark,
          secondaryContainer: Color(0xFF23305F),
          onSecondaryContainer: Color(0xFFDDE3FF),
          tertiary: AppColors.tertiary,
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFF93000A),
          onTertiaryContainer: Color(0xFFFFDAD6),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          errorContainer: Color(0xFF93000A),
          onErrorContainer: Color(0xFFFFDAD6),
          surface: AppColors.cardDark,
          onSurface: AppColors.textPrimaryDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
          surfaceContainerLowest: Color(0xFF0B0F26),
          surfaceContainerLow: Color(0xFF12183A),
          surfaceContainer: Color(0xFF161C42),
          surfaceContainerHigh: Color(0xFF1E254E),
          surfaceContainerHighest: Color(0xFF27305C),
          surfaceDim: AppColors.bgDark,
          surfaceBright: Color(0xFF2A3157),
          outline: Color(0xFF4A5480),
          outlineVariant: AppColors.hairlineDark,
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: Color(0xFFE2E8F7),
          onInverseSurface: AppColors.cardDark,
          inversePrimary: AppColors.primary,
        ),
        scaffoldBg: AppColors.bgDark,
        card: AppColors.cardDark,
        track: AppColors.trackDark,
        hairline: AppColors.hairlineDark,
      );

  // ── Builder shared by both brightnesses ──────────────────────────────────
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
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

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
        titleTextStyle: AppText.screenTitle(size: 22, color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 24),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
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
          side: BorderSide(color: scheme.primary, width: 1.5),
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
                ? card
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
            ? scheme.surfaceContainerLow
            : AppColors.cardMutedLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: AppText.body(color: scheme.onSurfaceVariant),
        labelStyle: AppText.body(color: scheme.onSurfaceVariant),
        floatingLabelStyle: AppText.caption(color: scheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: track,
        selectedColor: scheme.primary.withValues(alpha: 0.12),
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
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary
              : track,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      dividerTheme: DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
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
          borderRadius: BorderRadius.circular(AppRadius.md),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(AppRadius.xxl)),
        ),
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
