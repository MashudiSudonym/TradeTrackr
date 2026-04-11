import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_component_themes.dart';

/// Central theme configuration for TradeTrackr.
///
/// Two themes: light and dark, both following the "Curated Ledger"
/// design system with tonal layering instead of shadows.
class AppTheme {
  const AppTheme._();

  /// Light theme — Warm Paper aesthetic.
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.success,
      onTertiary: AppColors.onSuccess,
      tertiaryContainer: AppColors.successContainer,
      onTertiaryContainer: AppColors.onSuccessContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: Colors.transparent,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceDim: AppColors.surfaceDim,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  /// Dark theme — Inverse Surface aesthetic.
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkInversePrimary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryFixed,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryDim,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: Color(0xFF34C759), // Brighter green for dark
      onTertiary: AppColors.onSuccess,
      tertiaryContainer: AppColors.successDim,
      onTertiaryContainer: AppColors.successContainer,
      error: Color(0xFFff453a), // Brighter error for dark
      onError: AppColors.onError,
      errorContainer: AppColors.errorDim,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkInverseOnSurface,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      shadow: Colors.transparent,
      surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      surfaceDim: AppColors.darkSurface,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: AppTypography.buildTextTheme(),
      cardTheme: AppComponentThemes.cardTheme,
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme,
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme,
      textButtonTheme: AppComponentThemes.textButtonTheme,
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme,
      chipTheme: AppComponentThemes.chipTheme,
      appBarTheme: AppComponentThemes.appBarTheme,
      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBarTheme,
      floatingActionButtonTheme: AppComponentThemes.floatingActionButtonTheme,
      dividerTheme: AppComponentThemes.dividerTheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }
}
