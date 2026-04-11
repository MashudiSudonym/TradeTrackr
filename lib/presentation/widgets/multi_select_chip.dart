import 'package:flutter/material.dart';

/// Generic multi-select chip group following the TradeTrackr design system.
///
/// Default chip: surfaceContainerHighest background, onSurfaceVariant text.
/// Selected chip: primaryContainer background, onPrimaryContainer text.
/// Shape: pill (StadiumBorder).
class MultiSelectChip<T> extends StatelessWidget {
  const MultiSelectChip({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.labelBuilder,
  });

  final List<T> options;
  final List<T> selectedValues;
  final ValueChanged<List<T>> onSelectionChanged;
  final String Function(T value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return GestureDetector(
          onTap: () {
            final newSelection = List<T>.from(selectedValues);
            if (isSelected) {
              newSelection.remove(option);
            } else {
              newSelection.add(option);
            }
            onSelectionChanged(newSelection);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? cs.primaryContainer
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              labelBuilder != null ? labelBuilder!(option) : option.toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
