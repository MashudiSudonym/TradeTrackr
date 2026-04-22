/// Responsive widgets for TradeTrackr.
///
/// This library provides a collection of responsive widgets that adapt
/// to different screen sizes (mobile, tablet, desktop).
///
/// ## Usage
///
/// ```dart
/// import 'package:tradetrackr/presentation/widgets/responsive/responsive.dart';
///
/// // Use responsive padding
/// ResponsivePadding(child: MyContent())
///
/// // Use responsive grid
/// ResponsiveGrid(children: [Card1(), Card2(), Card3(), Card4()])
///
/// // Use responsive builder for conditional layouts
/// ResponsiveBuilder(
///   builder: (context, size, isMobile, isTablet, isDesktop) {
///     if (isDesktop) return DesktopLayout();
///     return MobileLayout();
///   },
/// )
/// ```
library;

export 'responsive_builder.dart';
export 'responsive_center.dart';
export 'responsive_grid.dart';
export 'responsive_padding.dart';
