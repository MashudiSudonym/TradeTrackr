import 'package:flutter/material.dart';

import '../../domain/enums/close_reason.dart';
import '../../domain/enums/trade_side.dart';
import 'date_range_picker.dart';
import 'multi_select_chip.dart';
import 'pill_toggle.dart';

/// Analytics filter bar for the dashboard charts section.
///
/// Provides filters for:
/// - Date range (DateRangePicker chip)
/// - Symbol (multi-select chips)
/// - Side (pill toggle: BUY / SELL / All)
/// - Close reason (multi-select chips)
class AnalyticsFilterBar extends StatelessWidget {
  const AnalyticsFilterBar({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateRangeChanged,
    this.selectedSymbols = const [],
    this.availableSymbols = const [],
    this.onSymbolsChanged,
    this.selectedSide,
    this.onSideChanged,
    this.selectedReasons = const [],
    this.onReasonsChanged,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?>? onDateRangeChanged;
  final List<String> selectedSymbols;
  final List<String> availableSymbols;
  final ValueChanged<List<String>>? onSymbolsChanged;
  final TradeSide? selectedSide;
  final ValueChanged<TradeSide?>? onSideChanged;
  final List<CloseReason> selectedReasons;
  final ValueChanged<List<CloseReason>>? onReasonsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Date range + Side toggle
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            DateRangePicker(
              startDate: startDate,
              endDate: endDate,
              onRangeSelected: onDateRangeChanged,
            ),
            if (onSideChanged != null)
              PillToggle<TradeSide?>(
                options: const [
                  PillOption(value: null, label: 'All'),
                  PillOption(value: TradeSide.buy, label: 'BUY'),
                  PillOption(value: TradeSide.sell, label: 'SELL'),
                ],
                selected: selectedSide,
                onChanged: onSideChanged!,
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Symbol multi-select
        if (availableSymbols.isNotEmpty && onSymbolsChanged != null)
          MultiSelectChip<String>(
            options: availableSymbols,
            selectedValues: selectedSymbols,
            onSelectionChanged: onSymbolsChanged!,
          ),
        if (availableSymbols.isNotEmpty) const SizedBox(height: 12),
        // Row 3: Reason multi-select
        if (onReasonsChanged != null)
          MultiSelectChip<CloseReason>(
            options: CloseReason.values,
            selectedValues: selectedReasons,
            onSelectionChanged: onReasonsChanged!,
            labelBuilder: (reason) => reason.name.toUpperCase(),
          ),
      ],
    );
  }
}
