import 'package:flutter/material.dart';

/// ALL CAPS form field label following the TradeTrackr design system.
///
/// Uses Inter w500, 12px, with 0.8 letter-spacing.
/// Typically placed above text input fields.
class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    super.key,
    required this.label,
    this.color,
  });

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          height: 1.3,
          color: color ?? cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
