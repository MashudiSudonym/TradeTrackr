import 'package:flutter/material.dart';

import '../../domain/enums/trade_side.dart';

/// Pill-shaped chip displaying the trade side (BUY or SELL).
///
/// BUY: primary background at 10% opacity with primary text.
/// SELL: secondaryContainer background with onSecondaryContainer text.
class SideChip extends StatelessWidget {
  const SideChip({super.key, required this.side});

  final TradeSide side;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBuy = side == TradeSide.buy;

    final bgColor = isBuy
        ? colorScheme.primary.withValues(alpha: 0.10)
        : colorScheme.secondaryContainer;
    final textColor =
        isBuy ? colorScheme.primary : colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        side.name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: textColor,
        ),
      ),
    );
  }
}
