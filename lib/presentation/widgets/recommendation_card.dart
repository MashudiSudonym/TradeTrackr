import 'package:flutter/material.dart';

import '../../domain/enums/severity.dart';
import '../../domain/entities/recommendation.dart';

/// Card displaying a recommendation from the analysis engine.
///
/// Shows severity indicator, title, description, and a "View Details" link.
/// Severity-based color coding: info=tertiary, warning=outline variant,
/// critical=error.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onTap,
  });

  final Recommendation recommendation;
  final VoidCallback? onTap;

  Color _severityColor(ColorScheme colorScheme) => switch (recommendation.severity) {
        Severity.info => colorScheme.tertiary,
        Severity.warning => colorScheme.outline,
        Severity.critical => colorScheme.error,
      };

  IconData get _severityIcon => switch (recommendation.severity) {
        Severity.info => Icons.info_outline,
        Severity.warning => Icons.warning_amber_outlined,
        Severity.critical => Icons.error_outline,
      };

  String get _severityLabel => switch (recommendation.severity) {
        Severity.info => 'INSIGHT',
        Severity.warning => 'WARNING',
        Severity.critical => 'CRITICAL',
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final severityColor = _severityColor(colorScheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Severity label row
            Row(
              children: [
                Icon(_severityIcon, size: 16, color: severityColor),
                const SizedBox(width: 6),
                Text(
                  _severityLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              recommendation.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              recommendation.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            // View Details link
            Row(
              children: [
                Text(
                  'View Details',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
