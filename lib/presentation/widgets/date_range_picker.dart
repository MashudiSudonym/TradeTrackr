import 'package:flutter/material.dart';

/// Date range picker chip following the TradeTrackr design system.
///
/// Shows a tappable chip that opens a date range picker dialog.
/// Displays the selected range or a placeholder label.
class DateRangePicker extends StatelessWidget {
  const DateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onRangeSelected,
    this.label = 'Date Range',
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?>? onRangeSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasRange = startDate != null && endDate != null;

    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: now,
          initialDateRange: hasRange
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: cs,
              ),
              child: child!,
            );
          },
        );
        onRangeSelected?.call(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: hasRange ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: hasRange ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              hasRange
                  ? '${_formatDate(startDate!)} – ${_formatDate(endDate!)}'
                  : label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: hasRange ? FontWeight.w600 : FontWeight.w500,
                color:
                    hasRange ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              ),
            ),
            if (hasRange) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => onRangeSelected?.call(null),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
