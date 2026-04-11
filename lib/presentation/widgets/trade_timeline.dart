import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Vertical timeline showing trade lifecycle from open to close.
///
/// Open event shown with outline dot, close event with primary dot.
/// Connected by a vertical line. Optional notes can be displayed.
class TradeTimeline extends StatelessWidget {
  const TradeTimeline({
    super.key,
    required this.openTime,
    this.closeTime,
    this.notes,
  });

  final DateTime openTime;
  final DateTime? closeTime;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline track
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Open dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 2,
                    ),
                  ),
                ),
                // Connecting line
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                // Close dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: closeTime != null
                        ? colorScheme.primary
                        : colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Timeline events
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Open event
                _TimelineEvent(
                  label: 'OPENED',
                  time: openTime,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 24),
                // Close event
                _TimelineEvent(
                  label: closeTime != null ? 'CLOSED' : 'OPEN',
                  time: closeTime,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  fallbackText: closeTime == null ? 'Still open' : null,
                ),
                if (notes != null && notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notes!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  const _TimelineEvent({
    required this.label,
    required this.time,
    required this.colorScheme,
    required this.textTheme,
    this.fallbackText,
  });

  final String label;
  final DateTime? time;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String? fallbackText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time != null
              ? DateFormat('dd MMM yyyy, HH:mm').format(time!)
              : (fallbackText ?? '--'),
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
