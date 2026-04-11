import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mock/chart_mock_data.dart';
import 'chart_container.dart';

/// Donut-style pie chart showing close-reason distribution.
///
/// Four segments: TP (Forest green), SL (Muted Brick), User (Crimson),
/// Manual (Warm Graphite). Center displays total trade count.
/// Uses mock data from [ChartMockData.reasonDistribution].
class WinLossByReasonChart extends StatelessWidget {
  const WinLossByReasonChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const data = ChartMockData.reasonDistribution;
    final totalTrades = data.fold(0, (sum, item) => sum + item.count);

    // Map mock hex colors to theme tokens for consistency.
    final segmentColors = [
      cs.tertiary, // TP — Forest green
      cs.error, // SL — Muted Brick
      cs.primary, // User — Crimson
      cs.secondary, // Manual — Warm Graphite
    ];

    return ChartContainer(
      title: 'CLOSE REASON DISTRIBUTION',
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Donut chart
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 56,
              sections: List.generate(data.length, (i) {
                final item = data[i];
                final percentage = (item.count / totalTrades) * 100;
                return PieChartSectionData(
                  value: item.count.toDouble(),
                  color: segmentColors[i],
                  radius: 36,
                  title: '${percentage.toStringAsFixed(0)}%',
                  titleStyle: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.surfaceContainerLowest,
                  ),
                  titlePositionPercentageOffset: 0.6,
                );
              }),
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {},
              ),
            ),
          ),
          // Center label with total count
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                totalTrades.toString(),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'TRADES',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
