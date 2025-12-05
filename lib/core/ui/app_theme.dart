import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData light() {
    final textTheme = buildAppTextTheme();
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      tertiary: AppColors.primaryVariant,
      onTertiary: Colors.white,
      surfaceTint: AppColors.primary,
      outline: AppColors.border,
    );

    return _buildTheme(colorScheme, textTheme, Brightness.light);
  }

  /// Dark theme
  static ThemeData dark() {
    final textTheme = buildAppTextTheme(isDark: true);
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF82B1FF),
      onPrimary: Color(0xFF003258),
      secondary: Color(0xFF80CBC4),
      onSecondary: Color(0xFF00332F),
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE1E1E1),
      tertiary: Color(0xFF448AFF),
      onTertiary: Colors.black,
      surfaceTint: Color(0xFF82B1FF),
      outline: Color(0xFF3C3C3C),
      surfaceContainerHighest: Color(0xFF2D2D2D),
      onSurfaceVariant: Color(0xFFB0B0B0),
      primaryContainer: Color(0xFF004880),
      onPrimaryContainer: Color(0xFFD1E4FF),
      secondaryContainer: Color(0xFF004D47),
      onSecondaryContainer: Color(0xFFA7F3EC),
      tertiaryContainer: Color(0xFF0057CE),
      onTertiaryContainer: Color(0xFFD1E4FF),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
    );

    return _buildTheme(colorScheme, textTheme, Brightness.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(isDark ? 0.3 : 1),
          ),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
