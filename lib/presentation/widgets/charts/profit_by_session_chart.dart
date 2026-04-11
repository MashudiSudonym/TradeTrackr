import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mock/chart_mock_data.dart';
import 'chart_container.dart';

/// Vertical bar chart showing profit by trading session.
///
/// Three bars: Asian (00-08), London (07-16), New York (12-21).
/// Positive bars are Forest green (cs.tertiary), negative bars are
/// Muted Brick (cs.error). Uses mock data from [ChartMockData.profitBySession].
class ProfitBySessionChart extends StatelessWidget {
  const ProfitBySessionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const data = ChartMockData.profitBySession;

    final maxAbsValue = data
        .map((s) => s.profit.abs())
        .reduce((a, b) => a > b ? a : b);
    final yInterval = (maxAbsValue * 1.2 / 4).ceilToDouble();

    return ChartContainer(
      title: 'PROFIT BY SESSION',
      height: 260,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: -(maxAbsValue * 1.2).ceilToDouble(),
          maxY: (maxAbsValue * 1.2).ceilToDouble(),
          barGroups: List.generate(data.length, (i) {
            final session = data[i];
            final isPositive = session.profit >= 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: session.profit,
                  color: isPositive ? cs.tertiary : cs.error,
                  width: 40,
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
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].session,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.2,
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
