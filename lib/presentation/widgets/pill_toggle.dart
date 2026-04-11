import 'package:flutter/material.dart';

/// Selectable pill toggle group following the TradeTrackr design system.
///
/// Default chip: surfaceContainerHighest background, onSurfaceVariant text.
/// Selected chip: primaryContainer background, onPrimaryContainer text.
/// Shape: pill (StadiumBorder).
class PillToggle<T> extends StatelessWidget {
  const PillToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.labelBuilder,
  });

  final List<PillOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Optional builder for custom label text. Defaults to option.label.
  final String Function(T value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == selected;
          return GestureDetector(
            onTap: () => onChanged(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                labelBuilder != null
                    ? labelBuilder!(option.value)
                    : option.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for pill toggle options.
class PillOption<T> {
  const PillOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}
