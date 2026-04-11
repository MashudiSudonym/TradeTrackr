import 'package:flutter/material.dart';

/// Row displaying a labeled price/value with optional accent bar.
///
/// surfaceContainerLow background, rounded-xl (16px) corners.
/// Label left in ALL CAPS, value right in Manrope bold.
/// Optional 4px left accent bar.
class PricingRow extends StatelessWidget {
  const PricingRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.accentColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (accentColor != null)
            Container(
              width: 4,
              height: 24,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
