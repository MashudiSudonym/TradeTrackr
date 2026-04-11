import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/closed_position.dart';
import '../providers/analytics_provider.dart';
import '../providers/trade_provider.dart';

/// Closed Trades list page.
///
/// Shows all closed positions with search, filter chips,
/// and inline metric badges.
class TradeListPage extends ConsumerStatefulWidget {
  const TradeListPage({super.key});

  @override
  ConsumerState<TradeListPage> createState() => _TradeListPageState();
}

class _TradeListPageState extends ConsumerState<TradeListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // ── Top App Bar ──────────────────────────────────
          _buildTopBar(cs),

          // ── Hero Section ─────────────────────────────────
          _buildHero(cs),

          // ── Filter Bar ───────────────────────────────────
          _buildFilterBar(cs),

          // ── Trade Cards List ─────────────────────────────
          Expanded(
            child: _buildTradeList(cs),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(ColorScheme cs) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Trade',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'Trackr',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: cs.onSurfaceVariant, size: 24),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.file_download_outlined, color: cs.onSurfaceVariant, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(ColorScheme cs) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Closed Trades',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          // Inline metric chips
          Row(
            children: [
              _MetricChip(
                cs: cs,
                label: 'WIN RATE',
                value: analyticsAsync.when(
                  data: (a) => a.formattedWinRate,
                  loading: () => '...',
                  error: (_, __) => 'N/A',
                ),
              ),
              const SizedBox(width: 12),
              _MetricChip(
                cs: cs,
                label: 'PROFIT FACTOR',
                value: analyticsAsync.when(
                  data: (a) => a.profitFactor.toStringAsFixed(2),
                  loading: () => '...',
                  error: (_, __) => 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Search input
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search symbol...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Date range chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'All Time',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Export button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.ios_share, size: 18, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeList(ColorScheme cs) {
    final tradesAsync = ref.watch(tradeListProvider);

    return tradesAsync.when(
      data: (trades) {
        var filtered = trades;
        if (_searchQuery.isNotEmpty) {
          filtered = trades
              .where((t) =>
                  t.symbol.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
        }
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No trades found',
                style: GoogleFonts.inter(fontSize: 14, color: cs.onSurfaceVariant),
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _TradeListCard(
                    trade: filtered[index],
                    cs: cs,
                  );
                },
              ),
            ),
            // Pagination text
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                'Showing 1-${filtered.length} of ${filtered.length} trades',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: cs.primary),
      ),
      error: (_, __) => Center(
        child: Text(
          'Could not load trades',
          style: GoogleFonts.inter(fontSize: 14, color: cs.error),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Inline Metric Chip
// ───────────────────────────────────────────────────────────────

class _MetricChip extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final String value;

  const _MetricChip({required this.cs, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Trade List Card
// ───────────────────────────────────────────────────────────────

class _TradeListCard extends StatelessWidget {
  final ClosedPosition trade;
  final ColorScheme cs;

  const _TradeListCard({required this.trade, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isWin = trade.isWin;
    final accentColor = isWin ? cs.tertiary : cs.error;

    return GestureDetector(
      onTap: () => context.push('/trades/${trade.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 4px left accent bar
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Symbol + Side + Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        trade.symbol,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: trade.side.name == 'BUY'
                              ? cs.tertiaryContainer.withValues(alpha: 0.3)
                              : cs.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          trade.side.name,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: trade.side.name == 'BUY'
                                ? cs.tertiary
                                : cs.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(trade.closeTime),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // P&L
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trade.formattedProfit,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trade.reason.description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
