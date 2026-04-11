import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/closed_position.dart';

/// Compact list showing recent closed trades with accent bars and P&L.
///
/// Displays up to [maxItems] trades in a column layout. Each row has
/// a 4px accent bar, symbol, close info, and right-aligned P&L.
/// Includes a "View All" link in the header.
class RecentTradesList extends StatelessWidget {
  const RecentTradesList({
    super.key,
    required this.trades,
    this.maxItems = 3,
    this.onViewAll,
  });

  final List<ClosedPosition> trades;
  final int maxItems;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayTrades = trades.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Trades',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Trade rows
        ...displayTrades.map((trade) => _buildTradeRow(
              context: context,
              position: trade,
              colorScheme: colorScheme,
              textTheme: textTheme,
            )),
      ],
    );
  }

  Widget _buildTradeRow({
    required BuildContext context,
    required ClosedPosition position,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final accentColor = position.isWin ? colorScheme.tertiary : colorScheme.error;
    final profitColor = position.isWin ? colorScheme.tertiary : colorScheme.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // 4px accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Symbol and close info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position.symbol,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd MMM yyyy').format(position.closeTime),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Right-aligned P&L
            Text(
              position.formattedProfit,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: profitColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
