import 'package:flutter/material.dart';

import '../section_label.dart';

/// Shared wrapper for all chart widgets.
///
/// Provides a consistent card container with:
/// - 12px radius
/// - surfaceContainerLow background (tonal layering)
/// - Section title in ALL CAPS
/// - Standard padding (16px)
class ChartContainer extends StatelessWidget {
  const ChartContainer({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.height,
    this.padding = const EdgeInsets.all(16),
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final double? height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionLabel(label: title, trailing: trailing),
            const SizedBox(height: 8),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
