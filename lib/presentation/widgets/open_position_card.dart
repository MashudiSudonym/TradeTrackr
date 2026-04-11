import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/open_position.dart';
import 'side_chip.dart';

/// Card displaying an open trade position with floating P/L.
///
/// Follows the "Curated Ledger" design system:
/// - surfaceContainerLow background, 12px radius
/// - 4px primary accent bar (position is still open, not win/loss)
/// - Icon circle + symbol + SideChip + open date
/// - Floating P/L right-aligned
/// - SL/TP row at bottom if set
/// - "Close" outline pill button
class OpenPositionCard extends StatefulWidget {
  const OpenPositionCard({
    super.key,
    required this.position,
    this.onTap,
    this.onClosePosition,
  });

  final OpenPosition position;
  final VoidCallback? onTap;
  final VoidCallback? onClosePosition;

  @override
  State<OpenPositionCard> createState() => _OpenPositionCardState();
}

class _OpenPositionCardState extends State<OpenPositionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();
  void _onTapUp(TapUpDetails _) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pos = widget.position;
    final floatingPL = pos.floatingProfit;
    final isProfitable = floatingPL >= 0;

    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Left accent bar — primary color for open positions
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: icon + symbol + side chip + date
                        Row(
                          children: [
                            // Icon circle
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHigh,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.trending_up,
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Symbol + side + date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        pos.symbol,
                                        style: GoogleFonts.manrope(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SideChip(side: pos.side),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Opened: ${DateFormat('dd MMM yyyy').format(pos.openTime)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Floating P/L
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatProfit(floatingPL),
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isProfitable
                                        ? colorScheme.tertiary
                                        : colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Floating P/L',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.8,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Bottom row: SL / TP if set + Close button
                        if (pos.stopLoss != null || pos.takeProfit != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (pos.stopLoss != null)
                                _SlTpLabel(
                                  label: 'SL',
                                  value: pos.stopLoss!,
                                  cs: colorScheme,
                                ),
                              if (pos.stopLoss != null &&
                                  pos.takeProfit != null)
                                const SizedBox(width: 16),
                              if (pos.takeProfit != null)
                                _SlTpLabel(
                                  label: 'TP',
                                  value: pos.takeProfit!,
                                  cs: colorScheme,
                                ),
                              const Spacer(),
                              // Close button
                              if (widget.onClosePosition != null)
                                GestureDetector(
                                  onTap: widget.onClosePosition,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorScheme.outline
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ] else if (widget.onClosePosition != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: widget.onClosePosition,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.outline
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    'Close',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatProfit(double profit) {
    final sign = profit >= 0 ? '+' : '';
    return '$sign${profit.toStringAsFixed(2)}';
  }
}

// ───────────────────────────────────────────────────────────────
// Helper Widgets
// ───────────────────────────────────────────────────────────────

class _SlTpLabel extends StatelessWidget {
  final String label;
  final double value;
  final ColorScheme cs;

  const _SlTpLabel({
    required this.label,
    required this.value,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          value.toStringAsFixed(5),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
