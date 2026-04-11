import 'package:flutter/material.dart';

/// ALL CAPS section heading following the TradeTrackr design system.
///
/// Uses Inter w500, 12px, with 0.8 letter-spacing in onSurfaceVariant color.
/// Optional trailing widget (e.g., "View All" link).
class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.label,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
              height: 1.3,
              color: cs.onSurfaceVariant,
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
