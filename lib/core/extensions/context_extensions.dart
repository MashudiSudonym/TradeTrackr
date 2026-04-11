import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Extension methods on [BuildContext] for responsive breakpoints.
///
/// Breakpoints follow common design standards:
/// - Mobile: < 600px (typical phones)
/// - Tablet: 600px - 900px (7" tablets, large phones)
/// - Desktop: > 900px (laptops, desktops, large tablets)
extension ContextExtensions on BuildContext {
  /// Width of the screen in logical pixels.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Height of the screen in logical pixels.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// True if the current screen width is less than 600px (mobile).
  bool get isMobile => screenWidth < 600;

  /// True if the current screen width is 600px or more (tablet+).
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// True if the current screen width is 900px or more (desktop).
  bool get isDesktop => screenWidth >= 900;

  /// True if the current platform is not web (native mobile/desktop).
  bool get isNative => !isWeb;

  /// True if the app is running on the web platform.
  bool get isWeb => Theme.of(this).platform == TargetPlatform.macOS ||
                    Theme.of(this).platform == TargetPlatform.windows ||
                    Theme.of(this).platform == TargetPlatform.linux &&
                    kIsWeb;

  /// Returns a value based on the current screen size.
  ///
  /// Example:
  /// ```dart
  /// final columns = context.responsiveValue(
  ///   mobile: 1,
  ///   tablet: 2,
  ///   desktop: 4,
  /// );
  /// ```
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Returns the number of columns for a grid based on screen size.
  ///
  /// Defaults: mobile=1, tablet=2, desktop=4
  int get gridColumns => responsiveValue(
        mobile: 1,
        tablet: 2,
        desktop: 4,
      );

  /// Returns horizontal padding based on screen size.
  ///
  /// Defaults: mobile=20, tablet=32, desktop=48
  double get horizontalPadding => responsiveValue(
        mobile: 20,
        tablet: 32,
        desktop: 48,
      );
}
