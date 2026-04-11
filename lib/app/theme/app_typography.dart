import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TradeTrackr typography tokens.
///
/// Two-font system:
/// - Manrope: headlines, display figures, page titles (weights 600-800)
/// - Inter: body text, labels, form inputs, chips (weights 400-700)
///
/// Data labels use ALL CAPS with 0.05rem letter-spacing.
class AppTypography {
  const AppTypography._();

  /// Manrope — for headlines and display figures.
  static TextStyle get manrope => GoogleFonts.manrope();

  /// Inter — for body text, labels, and functional text.
  static TextStyle get inter => GoogleFonts.inter();

  /// Display Large: Account balance, total P&L — Manrope w800, 56px.
  static TextStyle get displayLarge => GoogleFonts.manrope(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        height: 1.1,
      );

  /// Display Medium: Hero net P&L on trade detail — Manrope w800, 40px.
  static TextStyle get displayMedium => GoogleFonts.manrope(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        height: 1.15,
      );

  /// Headline Large: Large portfolio numbers — Manrope w800, 32px.
  static TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.01,
        height: 1.2,
      );

  /// Headline Medium: Page titles — Manrope w700, 24px.
  static TextStyle get headlineMedium => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01,
        height: 1.25,
      );

  /// Headline Small: Section headers — Manrope w600, 18px.
  static TextStyle get headlineSmall => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Body Large: Larger body text — Inter w400, 16px.
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Medium: Default body text — Inter w400, 14px.
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Small: Captions — Inter w400, 12px.
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Label Large: Button text — Inter w600, 14px.
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Label Medium: Data labels — Inter w500, 12px, ALL CAPS, wide tracking.
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        height: 1.3,
      );

  /// Label Small: Tiny labels — Inter w500, 10px.
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
      );

  /// Numeric data: Profit, Price — Manrope w600, 16px.
  static TextStyle get numericData => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1.3,
      );

  /// Build the TextTheme for ThemeData.
  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
