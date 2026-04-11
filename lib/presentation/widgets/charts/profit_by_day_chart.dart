import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mock/chart_mock_data.dart';
import 'chart_container.dart';

/// Vertical bar chart showing profit by day of week (Mon-Sun).
///
/// Positive bars are Forest green (cs.tertiary), negative bars are
/// Muted Brick (cs.error). Uses mock data from [ChartMockData.profitByDay].
class ProfitByDayChart extends StatelessWidget {
  const ProfitByDayChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const data = ChartMockData.profitByDay;

    const maxAbsValue = 285.0; // from mock data
    const yInterval = 85.0; // ceilToDouble() of 285*1.2/4

    return ChartContainer(
      title: 'PROFIT BY DAY',
      height: 260,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: -(maxAbsValue * 1.2).ceilToDouble(),
          maxY: (maxAbsValue * 1.2).ceilToDouble(),
          barGroups: List.generate(data.length, (i) {
            final day = data[i];
            final isPositive = day.profit >= 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: day.profit,
                  color: isPositive ? cs.tertiary : cs.error,
                  width: 24,
                  borderRadius: isPositive
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        )
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                ),
              ],
            );
          }),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: value == 0
                  ? cs.outline.withValues(alpha: 0.4)
                  : cs.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: value == 0 ? 1.5 : 1,
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
                reservedSize: 44,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  final absValue = value.abs();
                  final formatted = absValue >= 1000
                      ? '\$${(absValue / 1000).toStringAsFixed(1)}k'
                      : '\$${absValue.toStringAsFixed(0)}';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      value < 0 ? '-$formatted' : formatted,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
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
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].day,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => cs.onSurface,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final profit = data[groupIndex].profit;
                final prefix = profit >= 0 ? '+' : '';
                return BarTooltipItem(
                  '$prefix\$${profit.toStringAsFixed(0)}',
                  TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.surfaceContainerLowest,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
