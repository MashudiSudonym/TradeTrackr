import 'package:flutter/material.dart';

/// Filter bar with search input, date range toggle chips, and export button.
///
/// Search input with rounded-full shape and search icon.
/// Date range: 3 pill chips for filtering (e.g., Day, Week, Month).
/// Export button: dark pill with download icon.
class FilterBar extends StatefulWidget {
  const FilterBar({
    super.key,
    this.onSearchChanged,
    this.onDateRangeChanged,
    this.onExport,
  });

  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onDateRangeChanged;
  final VoidCallback? onExport;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final _searchController = TextEditingController();
  int _selectedDateRange = 0;

  static const _dateRangeOptions = ['Day', 'Week', 'Month'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Search input
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search trades...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Date range chips
        ...List.generate(_dateRangeOptions.length, (index) {
          final isSelected = _selectedDateRange == index;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedDateRange = index);
                widget.onDateRangeChanged?.call(_dateRangeOptions[index]);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _dateRangeOptions[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 4),
        // Export button
        GestureDetector(
          onTap: widget.onExport,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.download,
              size: 18,
              color: colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
