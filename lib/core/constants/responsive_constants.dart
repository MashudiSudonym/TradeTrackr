/// Responsive design constants for TradeTrackr.
///
/// This file defines centralized values for breakpoints, scale factors,
/// padding, and other responsive design tokens.
library;

/// Breakpoint values for responsive design.
///
/// These follow common design standards:
/// - Mobile: < 600px (typical phones)
/// - Tablet: 600px - 900px (7" tablets, large phones)
/// - Desktop: >= 900px (laptops, desktops, large tablets)
class ResponsiveBreakpoints {
  /// Mobile breakpoint: screens smaller than this are considered mobile.
  static const double mobile = 600;

  /// Tablet breakpoint: screens at least this wide but less than [desktop].
  static const double tablet = 900;

  /// Desktop breakpoint: screens this wide or larger are considered desktop.
  static const double desktop = 900;

  /// Maximum width for content on desktop (prevents content from becoming too wide).
  static const double maxContentWidth = 1200;

  /// Maximum width for centered content (forms, cards).
  static const double centeredContentWidth = 600;

  /// Maximum width for auth forms on larger screens.
  static const double authFormWidth = 400;
}

/// Scale factors for responsive typography and dimensions.
///
/// These factors are applied to base values defined for mobile.
class ResponsiveScale {
  /// No scaling (mobile baseline).
  static const double mobile = 1.0;

  /// Slight scaling for tablet (5% larger).
  static const double tablet = 1.05;

  /// Moderate scaling for desktop (10% larger).
  static const double desktop = 1.1;
}

/// Responsive padding values.
///
/// These provide consistent spacing across different screen sizes.
class ResponsivePadding {
  /// Horizontal/page padding for mobile.
  static const double mobile = 20.0;

  /// Horizontal/page padding for tablet.
  static const double tablet = 32.0;

  /// Horizontal/page padding for desktop.
  static const double desktop = 48.0;
}

/// Responsive spacing values for gaps between elements.
///
/// Smaller than page padding, used for internal spacing.
class ResponsiveSpacing {
  /// Spacing between elements on mobile.
  static const double mobile = 8.0;

  /// Spacing between elements on tablet.
  static const double tablet = 12.0;

  /// Spacing between elements on desktop.
  static const double desktop = 16.0;
}

/// Grid column counts for responsive layouts.
///
/// Defines how many columns to use in grid layouts at each breakpoint.
class ResponsiveGridColumns {
  /// Single column layout for mobile.
  static const int mobile = 1;

  /// Two column layout for tablet.
  static const int tablet = 2;

  /// Four column layout for desktop.
  static const int desktop = 4;
}

/// Border radius values for responsive designs.
///
/// Adjusts corner radius based on screen size (optional optimization).
class ResponsiveBorderRadius {
  /// Standard corner radius for mobile.
  static const double mobile = 12.0;

  /// Slightly larger corner radius for tablet.
  static const double tablet = 14.0;

  /// Larger corner radius for desktop.
  static const double desktop = 16.0;
}

/// Icon size values for responsive designs.
///
/// Scales icon sizes based on breakpoint.
class ResponsiveIconSize {
  /// Small icon size (mobile: 20px).
  static const double small = 20.0;

  /// Medium icon size (mobile: 24px).
  static const double medium = 24.0;

  /// Large icon size (mobile: 32px).
  static const double large = 32.0;

  /// Extra large icon size (mobile: 48px).
  static const double extraLarge = 48.0;
}
