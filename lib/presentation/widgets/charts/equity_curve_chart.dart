import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../mock/chart_mock_data.dart';
import '../pill_toggle.dart';
import 'chart_container.dart';

/// Time range options for the equity curve.
enum EquityTimeRange { oneWeek, oneMonth, all }

/// Interactive equity curve line chart with time range selector.
///
/// Displays account equity over time with a gradient fill below the line.
/// Uses mock data from [ChartMockData.equityCurvePoints].
class EquityCurveChart extends ConsumerStatefulWidget {
  const EquityCurveChart({super.key});

  @override
  ConsumerState<EquityCurveChart> createState() => _EquityCurveChartState();
}

class _EquityCurveChartState extends ConsumerState<EquityCurveChart> {
  EquityTimeRange _selectedRange = EquityTimeRange.all;

  List<FlSpot> get _spots {
    const points = ChartMockData.equityCurvePoints;
    final filtered = switch (_selectedRange) {
      EquityTimeRange.oneWeek => points.length > 3
          ? points.sublist(points.length - 3)
          : points,
      EquityTimeRange.oneMonth => points.length > 8
          ? points.sublist(points.length - 8)
          : points,
      EquityTimeRange.all => points,
    };

    return List.generate(
      filtered.length,
      (i) => FlSpot(i.toDouble(), filtered[i].value),
    );
  }

  List<String> get _dateLabels {
    const points = ChartMockData.equityCurvePoints;
    return switch (_selectedRange) {
      EquityTimeRange.oneWeek => points.length > 3
          ? points.sublist(points.length - 3).map((p) => p.date).toList()
          : points.map((p) => p.date).toList(),
      EquityTimeRange.oneMonth => points.length > 8
          ? points.sublist(points.length - 8).map((p) => p.date).toList()
          : points.map((p) => p.date).toList(),
      EquityTimeRange.all => points.map((p) => p.date).toList(),
    };
  }

  double get _minY {
    final values = _spots.map((s) => s.y).toList();
    return (values.reduce((a, b) => a < b ? a : b) * 0.995).floorToDouble();
  }

  double get _maxY {
    final values = _spots.map((s) => s.y).toList();
    return (values.reduce((a, b) => a > b ? a : b) * 1.005).ceilToDouble();
  }

  String _formatYValue(double value) {
    if (value >= 1000) {
      final k = value / 1000;
      return '\$${k.toStringAsFixed(k % 1 == 0 ? 0 : 1)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    final chartHeight = isMobile ? 280.0 : 350.0;
    final fontSize = context.responsiveFontSize(10);

    return ChartContainer(
      title: 'EQUITY CURVE',
      height: chartHeight,
      trailing: PillToggle<EquityTimeRange>(
        options: const [
          PillOption(value: EquityTimeRange.oneWeek, label: '1W'),
          PillOption(value: EquityTimeRange.oneMonth, label: '1M'),
          PillOption(value: EquityTimeRange.all, label: 'ALL'),
        ],
        selected: _selectedRange,
        onChanged: (range) => setState(() => _selectedRange = range),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return LineChart(
            LineChartData(
              minX: 0,
              maxX: (_spots.length - 1).toDouble(),
              minY: _minY,
              maxY: _maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (_maxY - _minY) / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: isMobile ? 48 : 56,
                    interval: (_maxY - _minY) / 4,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          _formatYValue(value),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: _spots.length > 8 ? 3 : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= _dateLabels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _dateLabels[index],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  preventCurveOverShooting: true,
                  barWidth: 2.5,
                  color: cs.primary,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, x, y, z) => FlDotCirclePainter(
                      radius: 3,
                      color: cs.primary,
                      strokeWidth: 1.5,
                      strokeColor: cs.surfaceContainerLowest,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cs.primary.withValues(alpha: 0.2),
                        cs.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => cs.onSurface,
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '\$${spot.y.toStringAsFixed(0)}',
                        TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: context.responsiveFontSize(13),
                          fontWeight: FontWeight.w700,
                          color: cs.surfaceContainerLowest,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
