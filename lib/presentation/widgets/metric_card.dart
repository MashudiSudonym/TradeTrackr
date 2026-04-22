import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';

/// Card displaying a single metric with label, value, and optional accent.
///
/// Uses surfaceContainerHigh background with 12px corner radius.
/// Label in ALL CAPS, value in Manrope bold display style.
/// Optional 4px left accent bar in the specified color.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.accentColor,
    this.trailing,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final Color? accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final trailing = this.trailing;
    final accentColor = this.accentColor;
    final padding = context.responsiveSpacing();

    return Container(
      padding: EdgeInsets.all(12 + padding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (accentColor != null)
            Container(
              width: 4,
              height: 40,
              margin: EdgeInsets.only(right: padding),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: padding / 2),
                Text(
                  value,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // ignore: use_null_aware_elements
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
