import 'package:flutter/widgets.dart';
import 'package:tradetrackr/core/extensions/context_extensions.dart';

/// A responsive grid that automatically adjusts column count based on screen size.
///
/// The grid adapts to screen size:
/// - Mobile: 1 column
/// - Tablet: 2 columns
/// - Desktop: 4 columns
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   children: [Card1(), Card2(), Card3(), Card4()],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  /// Creates a responsive grid widget.
  const ResponsiveGrid({
    required this.children,
    this.spacing,
    this.runSpacing,
    this.columnCount,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  /// The children to display in the grid.
  final List<Widget> children;

  /// Spacing between columns. If null, uses responsive spacing.
  final double? spacing;

  /// Spacing between rows. If null, uses responsive spacing.
  final double? runSpacing;

  /// Optional column count override. If null, uses the grid columns from
  /// ContextExtensions (1 for mobile, 2 for tablet, 4 for desktop).
  final int? columnCount;

  /// How children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How children should be aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final columns = columnCount ?? context.gridColumns;

    if (columns == 1 || children.length <= 1) {
      // Single column - use Column with spacing
      final effectiveSpacing = spacing ?? context.responsiveSpacing();

      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: effectiveSpacing),
            children[i],
          ]
        ],
      );
    }

    // Multi-column - use GridView
    final effectiveSpacing = spacing ?? context.responsiveSpacing();
    final effectiveRunSpacing = runSpacing ?? context.responsiveSpacing();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: effectiveRunSpacing,
        crossAxisSpacing: effectiveSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive grid with a custom aspect ratio for each child.
///
/// This is useful when you want grid items to maintain a specific
/// aspect ratio regardless of screen size.
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   aspectRatio: 1.5, // Width is 1.5x height
///   children: [MetricCard1(), MetricCard2(), ...],
/// )
/// ```
class ResponsiveGridAspectRatio extends StatelessWidget {
  /// Creates a responsive grid with aspect ratio.
  const ResponsiveGridAspectRatio({
    required this.children,
    required this.aspectRatio,
    this.spacing,
    this.columnCount,
    super.key,
  });

  /// The children to display in the grid.
  final List<Widget> children;

  /// The aspect ratio (width / height) for each child.
  final double aspectRatio;

  /// Spacing between items. If null, uses responsive spacing.
  final double? spacing;

  /// Optional column count override. If null, uses the grid columns from
  /// ContextExtensions (1 for mobile, 2 for tablet, 4 for desktop).
  final int? columnCount;

  @override
  Widget build(BuildContext context) {
    final columns = columnCount ?? context.gridColumns;
    final effectiveSpacing = spacing ?? context.responsiveSpacing();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: effectiveSpacing,
        crossAxisSpacing: effectiveSpacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive row that wraps its children on smaller screens.
///
/// On mobile, children wrap to multiple lines. On tablet and desktop,
/// they stay in a single row (unless space is insufficient).
///
/// Example:
/// ```dart
/// ResponsiveRow(
///   children: [Chip1(), Chip2(), Chip3()],
/// )
/// ```
class ResponsiveRow extends StatelessWidget {
  /// Creates a responsive row widget.
  const ResponsiveRow({
    required this.children,
    this.spacing,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    super.key,
  });

  /// The children to display in the row.
  final List<Widget> children;

  /// Spacing between children in the same run.
  final double? spacing;

  /// Spacing between runs (when wrapping).
  final double? runSpacing;

  /// How the runs should be placed along the main axis.
  final WrapAlignment alignment;

  /// How the runs should be placed along the cross axis.
  final WrapAlignment runAlignment;

  /// How children within a run should be aligned.
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final effectiveSpacing = spacing ?? context.responsiveSpacing();
    final effectiveRunSpacing = runSpacing ?? context.responsiveSpacing();

    return Wrap(
      spacing: effectiveSpacing,
      runSpacing: effectiveRunSpacing,
      alignment: alignment,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

/// A widget that builds different layouts for mobile and desktop.
///
/// This is useful when you need completely different layouts
/// rather than just adjusting spacing or columns.
///
/// Example:
/// ```dart
/// ResponsiveLayout(
///   mobile: () => MobileLayout(),
///   desktop: () => DesktopLayout(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  /// Creates a responsive layout widget.
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    required this.desktop,
    super.key,
  });

  /// Builder for mobile layout (< 600px).
  final WidgetBuilder mobile;

  /// Builder for tablet layout (600-899px). Falls back to [mobile] if null.
  final WidgetBuilder? tablet;

  /// Builder for desktop layout (>= 900px).
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop(context);
    }
    if (context.isTablet && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}
