import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/closed_position.dart';
import '../providers/trade_provider.dart';

/// Trade detail page showing full information for a single closed position.
///
/// Receives [tradeId] from the route parameters.
class TradeDetailPage extends ConsumerWidget {
  final String tradeId;

  const TradeDetailPage({super.key, required this.tradeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tradeAsync = ref.watch(tradeByIdProvider(tradeId));

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
        ),
        title: tradeAsync.when(
          data: (trade) => trade != null
              ? Text(
                  '${trade.symbol} ${trade.side.name}',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: cs.onSurfaceVariant),
          ),
        ],
      ),
      body: tradeAsync.when(
        data: (trade) {
          if (trade == null) {
            return Center(
              child: Text(
                'Trade not found',
                style: GoogleFonts.inter(fontSize: 14, color: cs.error),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero P&L Card ──────────────────────────
                _HeroPnlCard(trade: trade, cs: cs),
                const SizedBox(height: 24),

                // ── Status Card ────────────────────────────
                _StatusCard(trade: trade, cs: cs),
                const SizedBox(height: 24),

                // ── Timeline ───────────────────────────────
                _TimelineSection(trade: trade, cs: cs),
                const SizedBox(height: 24),

                // ── Pricing Rows ───────────────────────────
                _PricingSection(trade: trade, cs: cs),
                const SizedBox(height: 32),

                // ── Actions ────────────────────────────────
                _ActionButtons(cs: cs),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: cs.primary),
        ),
        error: (_, _) => Center(
          child: Text(
            'Error loading trade',
            style: GoogleFonts.inter(fontSize: 14, color: cs.error),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Hero P&L Card
// ───────────────────────────────────────────────────────────────

class _HeroPnlCard extends StatelessWidget {
  final ClosedPosition trade;
  final ColorScheme cs;

  const _HeroPnlCard({required this.trade, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isWin = trade.isWin;
    final accentColor = isWin ? cs.tertiary : cs.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 4px accent bar
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NET PROFIT',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trade.formattedProfit,
                  style: GoogleFonts.manrope(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    height: 1.15,
                    letterSpacing: -0.02,
                  ),
                ),
              ],
            ),
          ),
          // Sub metrics
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SubMetric(cs: cs, label: 'SWAP', value: trade.swap.toStringAsFixed(2)),
              const SizedBox(height: 8),
              _SubMetric(cs: cs, label: 'COMMISSION', value: trade.commission.toStringAsFixed(2)),
              const SizedBox(height: 8),
              _SubMetric(cs: cs, label: 'VOLUME', value: '${trade.volume.toStringAsFixed(1)} lots'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubMetric extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final String value;

  const _SubMetric({required this.cs, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Status Card
// ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final ClosedPosition trade;
  final ColorScheme cs;

  const _StatusCard({required this.trade, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isPositive = trade.reason.isPositive;
    final icon = isPositive ? Icons.check_circle_outline : Icons.cancel_outlined;
    final color = isPositive ? cs.tertiary : cs.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Text(
            trade.reason.description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            trade.symbol,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Timeline Section
// ───────────────────────────────────────────────────────────────

class _TimelineSection extends StatelessWidget {
  final ClosedPosition trade;
  final ColorScheme cs;

  const _TimelineSection({required this.trade, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIMELINE',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _TimelineRow(cs: cs, label: 'Opened', dt: trade.openTime),
        const SizedBox(height: 8),
        _TimelineRow(cs: cs, label: 'Closed', dt: trade.closeTime),
        const SizedBox(height: 8),
        _TimelineRow(
          cs: cs,
          label: 'Duration',
          displayText: _formatDuration(trade.holdingDuration),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    if (hours < 24) return '${hours}h';
    final days = d.inDays;
    final remainingHours = hours - (days * 24);
    return '${days}d ${remainingHours}h';
  }
}

class _TimelineRow extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final DateTime? dt;
  final String? displayText;

  const _TimelineRow({
    required this.cs,
    required this.label,
    this.dt,
    this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: cs.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: cs.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          displayText ?? _formatDateTime(dt!),
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d  $t';
  }
}

// ───────────────────────────────────────────────────────────────
// Pricing Section
// ───────────────────────────────────────────────────────────────

class _PricingSection extends StatelessWidget {
  final ClosedPosition trade;
  final ColorScheme cs;

  const _PricingSection({required this.trade, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _PricingRow(cs: cs, label: 'ENTRY PRICE', value: trade.openPrice.toStringAsFixed(2)),
          const SizedBox(height: 12),
          _PricingRow(cs: cs, label: 'EXIT PRICE', value: trade.closePrice.toStringAsFixed(2)),
          const SizedBox(height: 12),
          _PricingRow(
            cs: cs,
            label: 'STOP LOSS',
            value: trade.stopLoss?.toStringAsFixed(2) ?? '—',
          ),
          const SizedBox(height: 12),
          _PricingRow(
            cs: cs,
            label: 'TAKE PROFIT',
            value: trade.takeProfit?.toStringAsFixed(2) ?? '—',
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final String value;

  const _PricingRow({required this.cs, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: cs.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Action Buttons
// ───────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final ColorScheme cs;

  const _ActionButtons({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Edit button
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to edit page
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                child: Text(
                  'Edit Trade',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Delete button
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Show delete confirmation
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                child: Text(
                  'Delete',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.error,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
