import 'package:flutter/material.dart';

/// A builder that provides screen size context and responsive helpers.
///
/// This widget wraps [LayoutBuilder] and provides convenient access to
/// screen dimensions and breakpoint information.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, size, isMobile, isTablet, isDesktop) {
///     if (isMobile) return MobileLayout();
///     if (isTablet) return TabletLayout();
///     return DesktopLayout();
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive builder widget.
  const ResponsiveBuilder({
    required this.builder,
    super.key,
  });

  /// Builder function that receives size context and breakpoint flags.
  final Widget Function(
    BuildContext context,
    Size size,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final width = constraints.maxWidth;

        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 900;
        final isDesktop = width >= 900;

        return builder(context, size, isMobile, isTablet, isDesktop);
      },
    );
  }
}

/// A simplified builder that only calls the builder for the current breakpoint.
///
/// This is useful when you want to provide completely different widgets
/// for each breakpoint rather than responsive properties within a single widget.
///
/// Example:
/// ```dart
/// ResponsiveBreakpointBuilder(
///   mobile: () => MobileWidget(),
///   tablet: () => TabletWidget(),
///   desktop: () => DesktopWidget(),
/// )
/// ```
class ResponsiveBreakpointBuilder extends StatelessWidget {
  /// Creates a breakpoint builder widget.
  const ResponsiveBreakpointBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  /// Widget builder for mobile (< 600px).
  final WidgetBuilder mobile;

  /// Widget builder for tablet (600-899px). Falls back to [mobile] if null.
  final WidgetBuilder? tablet;

  /// Widget builder for desktop (>= 900px). Falls back to [tablet] or [mobile] if null.
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size, isMobile, isTablet, isDesktop) {
        if (isDesktop && desktop != null) {
          return desktop!(context);
        }
        if (isTablet && tablet != null) {
          return tablet!(context);
        }
        return mobile(context);
      },
    );
  }
}
