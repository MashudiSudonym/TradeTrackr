import 'package:flutter/widgets.dart';
import 'package:tradetrackr/core/extensions/context_extensions.dart';

/// A widget that applies responsive padding to its child.
///
/// The padding value automatically adjusts based on the screen size:
/// - Mobile: 20px
/// - Tablet: 32px
/// - Desktop: 48px
///
/// Example:
/// ```dart
/// ResponsivePadding(
///   child: Text('Content with responsive padding'),
/// )
/// ```
class ResponsivePadding extends StatelessWidget {
  /// Creates a responsive padding widget.
  const ResponsivePadding({
    required this.child,
    this.horizontal = true,
    this.vertical = true,
    this.padding,
    super.key,
  });

  /// The child widget to wrap with responsive padding.
  final Widget child;

  /// Whether to apply horizontal padding (left and right).
  final bool horizontal;

  /// Whether to apply vertical padding (top and bottom).
  final bool vertical;

  /// Optional custom padding values for each breakpoint.
  ///
  /// If provided, these values override the defaults.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.horizontalPadding;

    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: horizontal ? defaultPadding : 0,
          vertical: vertical ? defaultPadding : 0,
        );

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}

/// A widget that applies responsive spacing as a sized box.
///
/// The spacing value automatically adjusts based on the screen size:
/// - Mobile: 8px
/// - Tablet: 12px
/// - Desktop: 16px
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('First'),
///     ResponsiveSpacing(),
///     Text('Second'),
///   ],
/// )
/// ```
class ResponsiveSpacing extends StatelessWidget {
  /// Creates a responsive spacing widget.
  const ResponsiveSpacing({
    this.axis = Axis.vertical,
    this.multiplier = 1,
    super.key,
  });

  /// Which axis to create space on.
  ///
  /// - [Axis.vertical]: Vertical space (default).
  /// - [Axis.horizontal]: Horizontal space.
  final Axis axis;

  /// Multiplier for the spacing value.
  ///
  /// Use this to create larger or smaller gaps.
  /// For example, `multiplier: 2` creates a gap twice the default size.
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    final spacing = context.responsiveSpacing() * multiplier;

    return switch (axis) {
      Axis.horizontal => SizedBox(width: spacing),
      Axis.vertical => SizedBox(height: spacing),
    };
  }
}

/// A widget that applies responsive gap between children in a flexible layout.
///
/// Unlike [ResponsiveSpacing] which is a fixed spacer, this widget wraps
/// a [Row] or [Column] and applies responsive gaps between children.
///
/// Example:
/// ```dart
/// ResponsiveGap(
///   direction: Axis.horizontal,
///   children: [Chip1(), Chip2(), Chip3()],
/// )
/// ```
class ResponsiveGap extends StatelessWidget {
  /// Creates a responsive gap widget for Row/Column.
  const ResponsiveGap({
    required this.children,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  /// The children to display with gaps between them.
  final List<Widget> children;

  /// The direction of the main axis (horizontal for Row, vertical for Column).
  final Axis direction;

  /// How the children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How the children should be aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final spacing = context.responsiveSpacing();

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          direction == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
    }

    return direction == Axis.horizontal
        ? Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: spacedChildren,
          )
        : Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: spacedChildren,
          );
  }
}
