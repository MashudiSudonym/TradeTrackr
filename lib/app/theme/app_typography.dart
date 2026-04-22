import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/extensions/context_extensions.dart';

/// TradeTrackr typography tokens.
///
/// Two-font system:
/// - Manrope: headlines, display figures, page titles (weights 600-800)
/// - Inter: body text, labels, form inputs, chips (weights 400-700)
///
/// Data labels use ALL CAPS with 0.05rem letter-spacing.
///
/// Responsive scaling: Font sizes scale based on screen size using textScaleFactor.
class AppTypography {
  const AppTypography._();

  /// Manrope — for headlines and display figures.
  static TextStyle get manrope => GoogleFonts.manrope();

  /// Inter — for body text, labels, and functional text.
  static TextStyle get inter => GoogleFonts.inter();

  /// Display Large: Account balance, total P&L — Manrope w800, 56px.
  static TextStyle displayLarge(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 56 * scale,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.02,
      height: 1.1,
    );
  }

  /// Display Medium: Hero net P&L on trade detail — Manrope w800, 40px.
  static TextStyle displayMedium(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 40 * scale,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.02,
      height: 1.15,
    );
  }

  /// Headline Large: Large portfolio numbers — Manrope w800, 32px.
  static TextStyle headlineLarge(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 32 * scale,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.01,
      height: 1.2,
    );
  }

  /// Headline Medium: Page titles — Manrope w700, 24px.
  static TextStyle headlineMedium(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 24 * scale,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.01,
      height: 1.25,
    );
  }

  /// Headline Small: Section headers — Manrope w600, 18px.
  static TextStyle headlineSmall(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 18 * scale,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  /// Body Large: Larger body text — Inter w400, 16px.
  static TextStyle bodyLarge(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 16 * scale,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  /// Body Medium: Default body text — Inter w400, 14px.
  static TextStyle bodyMedium(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 14 * scale,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  /// Body Small: Captions — Inter w400, 12px.
  static TextStyle bodySmall(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 12 * scale,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );
  }

  /// Label Large: Button text — Inter w600, 14px.
  static TextStyle labelLarge(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 14 * scale,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  /// Label Medium: Data labels — Inter w500, 12px, ALL CAPS, wide tracking.
  static TextStyle labelMedium(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 12 * scale,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.8,
      height: 1.3,
    );
  }

  /// Label Small: Tiny labels — Inter w500, 10px.
  static TextStyle labelSmall(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.inter(
      fontSize: 10 * scale,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.3,
    );
  }

  /// Numeric data: Profit, Price — Manrope w600, 16px.
  static TextStyle numericData(BuildContext context) {
    final scale = context.textScaleFactor;
    return GoogleFonts.manrope(
      fontSize: 16 * scale,
      fontWeight: FontWeight.w600,
      fontFeatures: const [FontFeature.tabularFigures()],
      height: 1.3,
    );
  }

  /// Legacy non-responsive text styles (kept for backward compatibility).
  /// Use the context-aware versions above for responsive behavior.

  /// Display Large: Account balance, total P&L — Manrope w800, 56px.
  static TextStyle get displayLargeLegacy => GoogleFonts.manrope(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        height: 1.1,
      );

  /// Display Medium: Hero net P&L on trade detail — Manrope w800, 40px.
  static TextStyle get displayMediumLegacy => GoogleFonts.manrope(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        height: 1.15,
      );

  /// Headline Large: Large portfolio numbers — Manrope w800, 32px.
  static TextStyle get headlineLargeLegacy => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.01,
        height: 1.2,
      );

  /// Headline Medium: Page titles — Manrope w700, 24px.
  static TextStyle get headlineMediumLegacy => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01,
        height: 1.25,
      );

  /// Headline Small: Section headers — Manrope w600, 18px.
  static TextStyle get headlineSmallLegacy => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// Body Large: Larger body text — Inter w400, 16px.
  static TextStyle get bodyLargeLegacy => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Medium: Default body text — Inter w400, 14px.
  static TextStyle get bodyMediumLegacy => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Body Small: Captions — Inter w400, 12px.
  static TextStyle get bodySmallLegacy => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// Label Large: Button text — Inter w600, 14px.
  static TextStyle get labelLargeLegacy => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Label Medium: Data labels — Inter w500, 12px, ALL CAPS, wide tracking.
  static TextStyle get labelMediumLegacy => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        height: 1.3,
      );

  /// Label Small: Tiny labels — Inter w500, 10px.
  static TextStyle get labelSmallLegacy => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
      );

  /// Numeric data: Profit, Price — Manrope w600, 16px.
  static TextStyle get numericDataLegacy => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1.3,
      );

  /// Build the responsive TextTheme for ThemeData.
  ///
  /// This method requires a BuildContext to determine the appropriate
  /// font scaling for the current screen size.
  static TextTheme buildResponsiveTextTheme(BuildContext context) {
    return TextTheme(
      displayLarge: displayLarge(context),
      displayMedium: displayMedium(context),
      headlineLarge: headlineLarge(context),
      headlineMedium: headlineMedium(context),
      headlineSmall: headlineSmall(context),
      bodyLarge: bodyLarge(context),
      bodyMedium: bodyMedium(context),
      bodySmall: bodySmall(context),
      labelLarge: labelLarge(context),
      labelMedium: labelMedium(context),
      labelSmall: labelSmall(context),
    );
  }

  /// Build the non-responsive TextTheme for ThemeData (legacy).
  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: displayLargeLegacy,
      displayMedium: displayMediumLegacy,
      headlineLarge: headlineLargeLegacy,
      headlineMedium: headlineMediumLegacy,
      headlineSmall: headlineSmallLegacy,
      bodyLarge: bodyLargeLegacy,
      bodyMedium: bodyMediumLegacy,
      bodySmall: bodySmallLegacy,
      labelLarge: labelLargeLegacy,
      labelMedium: labelMediumLegacy,
      labelSmall: labelSmallLegacy,
    );
  }
}
