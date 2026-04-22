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

  /// Returns responsive padding value (same as horizontalPadding).
  double responsivePadding() => horizontalPadding;

  /// Returns responsive EdgeInsets.all based on screen size.
  ///
  /// Defaults: mobile=20, tablet=32, desktop=48
  EdgeInsets responsiveEdgeInsets() => EdgeInsets.all(horizontalPadding);

  /// Returns responsive spacing value based on screen size.
  ///
  /// Useful for consistent spacing between elements.
  /// Defaults: mobile=8, tablet=12, desktop=16
  double responsiveSpacing() => responsiveValue(
        mobile: 8.0,
        tablet: 12.0,
        desktop: 16.0,
      );

  /// Returns responsive font size based on mobile size and current breakpoint.
  ///
  /// Scales the mobile font size by a factor based on screen size.
  /// Example:
  /// ```dart
  /// final fontSize = context.responsiveFontSize(14); // 14 on mobile, ~15 on tablet, ~16 on desktop
  /// ```
  double responsiveFontSize(double mobileSize) {
    final scale = textScaleFactor;
    return mobileSize * scale;
  }

  /// Returns responsive width based on mobile width and current breakpoint.
  ///
  /// Scales the mobile width by a factor based on screen size.
  double responsiveWidth(double mobileWidth) {
    final scale = textScaleFactor;
    return mobileWidth * scale;
  }

  /// Returns responsive height based on mobile height and current breakpoint.
  ///
  /// Scales the mobile height by a factor based on screen size.
  double responsiveHeight(double mobileHeight) {
    final scale = textScaleFactor;
    return mobileHeight * scale;
  }

  /// Returns the screen size as a [Size] object.
  Size get screenSize => MediaQuery.of(this).size;

  /// True if the current orientation is portrait.
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// True if the current orientation is landscape.
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Returns the text scale factor for the current breakpoint.
  ///
  /// This factor is used to scale font sizes and dimensions for larger screens.
  /// Defaults: mobile=1.0, tablet=1.05, desktop=1.1
  double get textScaleFactor => responsiveValue(
        mobile: 1.0,
        tablet: 1.05,
        desktop: 1.1,
      );

  /// Returns the maximum width constraint for content on the current screen.
  ///
  /// On desktop, this returns a max-width constraint to prevent content from
  /// becoming too wide. On mobile and tablet, returns double.infinity.
  ///
  /// Defaults: mobile/tablet=infinity, desktop=1200
  double get maxContentWidth => responsiveValue(
        mobile: double.infinity,
        tablet: double.infinity,
        desktop: 1200,
      );
}
