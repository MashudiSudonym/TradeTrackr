import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../mock/chart_mock_data.dart';
import 'chart_container.dart';

/// Vertical bar chart showing P/L distribution across profit/loss buckets.
///
/// Bars are colored green (cs.tertiary) for positive midpoints and
/// red (cs.error) for negative midpoints. Uses mock data from
/// [ChartMockData.plDistribution].
class PlDistributionChart extends StatelessWidget {
  const PlDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    final chartHeight = isMobile ? 240.0 : 300.0;
    const data = ChartMockData.plDistribution;
    final maxCount = data.map((b) => b.count).reduce((a, b) => a > b ? a : b);

    return ChartContainer(
      title: 'P/L DISTRIBUTION',
      height: chartHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = (constraints.maxWidth - 48) / data.length * 0.6;

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxCount * 1.2).ceilToDouble(),
              barGroups: List.generate(data.length, (i) {
                final bucket = data[i];
                final isPositive = bucket.midpoint >= 0;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: bucket.count.toDouble(),
                      color: isPositive ? cs.tertiary : cs.error,
                      width: barWidth,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxCount / 4,
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
                    reservedSize: 32,
                    interval: maxCount / 4,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          value.toInt().toString(),
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
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data[index].label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurfaceVariant,
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
                    return BarTooltipItem(
                      '${data[groupIndex].count} trades',
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
          );
        },
      ),
    );
  }
}
