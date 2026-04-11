import 'package:flutter/material.dart';

/// TradeTrackr color tokens from the Stitch design system.
///
/// "Curated Ledger" aesthetic — premium stationery journal.
/// Mood: Calm Authority. Airy, minimalist, editorial, refined.
///
/// CRITICAL RULES:
/// - Never use #000000 for text — always use Charcoal Ink (#2d3435)
/// - Never use "Alert Red" for errors — use Muted Brick (#9e422c)
/// - Depth via tonal layering, never shadows (except FABs)
/// - No 1px borders for sectioning — use background color shifts
class AppColors {
  const AppColors._();

  // ── Primary (Crimson Heart) ──────────────────────────────
  static const primary = Color(0xFFbe0038);
  static const primaryDim = Color(0xFFa80030);
  static const primaryContainer = Color(0xFFffdada);
  static const onPrimary = Color(0xFFfff6f5);
  static const onPrimaryContainer = Color(0xFFa60030);
  static const primaryFixed = Color(0xFF840024);

  // ── Success (Forest) ────────────────────────────────────
  static const success = Color(0xFF006f05);
  static const successDim = Color(0xFF006104);
  static const successContainer = Color(0xFF7aee68);
  static const onSuccessContainer = Color(0xFF005603);
  static const onSuccess = Color(0xFFebffe0);

  // ── Error (Muted Brick) ────────────────────────────────
  static const error = Color(0xFF9e422c);
  static const errorDim = Color(0xFF5c1202);
  static const errorContainer = Color(0xFFfe8b70);
  static const onErrorContainer = Color(0xFF742410);
  static const onError = Color(0xFFfff7f6);

  // ── Surface Hierarchy (Paper-on-Stone, tonal layering) ──
  static const surface = Color(0xFFf9f9f9); // Warm Paper — base
  static const surfaceContainerLow = Color(0xFFf2f4f4); // Ledger Sheet
  static const surfaceContainer = Color(0xFFebeeef); // Cool Mist
  static const surfaceContainerHigh = Color(0xFFe4e9ea); // Silver Mist
  static const surfaceContainerHighest = Color(0xFFdde4e5); // Pale Stone
  static const surfaceContainerLowest = Color(0xFFffffff); // Pure White
  static const surfaceDim = Color(0xFFd4dbdd); // Warm Dim
  static const surfaceBright = Color(0xFFf9f9f9);

  // ── Text ────────────────────────────────────────────────
  static const onSurface = Color(0xFF2d3435); // Charcoal Ink
  static const onSurfaceVariant = Color(0xFF5a6061); // Slate Detail
  static const outline = Color(0xFF757c7d); // Muted Steel
  static const outlineVariant = Color(0xFFadb3b4); // Ghost Line

  // ── Secondary ──────────────────────────────────────────
  static const secondary = Color(0xFF605f5f); // Warm Graphite
  static const secondaryDim = Color(0xFF535353);
  static const secondaryContainer = Color(0xFFe5e2e1); // Soft Linen
  static const onSecondary = Color(0xFFfbf8f8); // Snow White
  static const onSecondaryContainer = Color(0xFF3d3d3d);
  static const onSecondaryFixed = Color(0xFF403f3f);

  // ── Dark Mode (Inverse) ────────────────────────────────
  static const darkSurface = Color(0xFF0c0f0f); // Inverse Surface
  static const darkInversePrimary = Color(0xFFff5169);
  static const darkInverseOnSurface = Color(0xFF9c9d9d);
  static const darkOnSurface = Color(0xFFe2e3e3);
  static const darkOnSurfaceVariant = Color(0xFFc1c7c8);
  static const darkSurfaceContainerLow = Color(0xFF191c1c);
  static const darkSurfaceContainer = Color(0xFF1d2020);
  static const darkSurfaceContainerHigh = Color(0xFF272b2b);
  static const darkSurfaceContainerHighest = Color(0xFF323636);
  static const darkSurfaceContainerLowest = Color(0xFF0c0f0f);
  static const darkOutline = Color(0xFF8b9192);
  static const darkOutlineVariant = Color(0xFF414849);

  /// Ghost border at 15% opacity for identical-color backgrounds.
  static Color get ghostBorder => outlineVariant.withValues(alpha: 0.15);
}
