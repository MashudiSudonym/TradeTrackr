import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/analytics_provider.dart';
import '../providers/recommendation_provider.dart';
import '../providers/trade_provider.dart';
import '../../app/theme/app_colors.dart';
import '../widgets/widgets.dart';

/// Dashboard — the home screen of TradeTrackr.
///
/// Shows portfolio overview, bento metrics, equity chart placeholder,
/// and recent trades.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top App Bar ──────────────────────────────────
            _TopAppBar(cs: cs),

            // ── Hero Section ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HeroSection(cs: cs, ref: ref),
            ),

            const SizedBox(height: 32),

            // ── Bento Metrics ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _BentoMetrics(cs: cs, ref: ref),
            ),

            const SizedBox(height: 32),

            // ── Charts Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ChartsSection(cs: cs),
            ),

            const SizedBox(height: 32),

            // ── Recent Trades ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _RecentTradesSection(cs: cs, ref: ref),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Top App Bar
// ───────────────────────────────────────────────────────────────

class _TopAppBar extends StatelessWidget {
  final ColorScheme cs;

  const _TopAppBar({required this.cs});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            // Logo
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
              onPressed: () => context.push('/profile'),
              icon: Icon(Icons.settings_outlined, color: cs.onSurfaceVariant, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Hero Section
// ───────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final ColorScheme cs;
  final WidgetRef ref;

  const _HeroSection({required this.cs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final balanceAsync = ref.watch(analyticsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Label
        Text(
          'PORTFOLIO OVERVIEW',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        // Balance
        balanceAsync.when(
          data: (analytics) => Text(
            '\$${analytics.accountBalance.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              height: 1.1,
              letterSpacing: -0.02,
            ),
          ),
          loading: () => _shimmerText(width: 240, height: 56),
          error: (_, _) => Text(
            '\$0.00',
            style: GoogleFonts.manrope(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Trend indicator + Add Trade button
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up, size: 14, color: cs.tertiary),
                  const SizedBox(width: 4),
                  balanceAsync.when(
                    data: (a) => Text(
                      a.formattedTotalPnL,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.tertiary,
                      ),
                    ),
                    loading: () => _shimmerText(width: 60, height: 14),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Add Trade pill button
            GestureDetector(
              onTap: () => context.push('/trades/add'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDim],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    transform: GradientRotation(135 * 3.14159 / 180),
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18, color: cs.onPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'Add Trade',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Bento Metrics
// ───────────────────────────────────────────────────────────────

class _BentoMetrics extends StatelessWidget {
  final ColorScheme cs;
  final WidgetRef ref;

  const _BentoMetrics({required this.cs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(analyticsProvider);
    final recommendationsAsync = ref.watch(recommendationProvider);

    return analyticsAsync.when(
      data: (analytics) {
        final topRec = recommendationsAsync.value?.firstOrNull;
        return Row(
          children: [
            Expanded(
              child: _MetricCard(
                cs: cs,
                label: 'WIN RATE',
                value: analytics.formattedWinRate,
                child: _WinRateProgress(cs: cs, winRate: analytics.winRate),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                cs: cs,
                label: 'TOTAL PROFIT',
                value: analytics.formattedTotalPnL,
                valueColor:
                    analytics.totalProfitLoss >= 0 ? cs.tertiary : cs.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                cs: cs,
                label: 'TOP PICK',
                value: topRec?.title.split(' ').take(2).join(' ') ?? 'N/A',
                subtitle: topRec?.description.split('.').first,
              ),
            ),
          ],
        );
      },
      loading: () => Row(
        children: List.generate(
          3,
          (_) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _shimmerCard(),
            ),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final String value;
  final Color? valueColor;
  final String? subtitle;
  final Widget? child;

  const _MetricCard({
    required this.cs,
    required this.label,
    required this.value,
    this.valueColor,
    this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor ?? cs.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ],
      ),
    );
  }
}

class _WinRateProgress extends StatelessWidget {
  final ColorScheme cs;
  final double winRate;

  const _WinRateProgress({required this.cs, required this.winRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: winRate / 100,
            backgroundColor: cs.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(cs.tertiary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Charts Section — Analytics + Recommendations
// ───────────────────────────────────────────────────────────────

class _ChartsSection extends StatelessWidget {
  final ColorScheme cs;

  const _ChartsSection({required this.cs});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Analytics Filter Bar
        AnalyticsFilterBar(),

        SizedBox(height: 16),

        // Equity Curve Chart
        EquityCurveChart(),

        SizedBox(height: 16),

        // P/L Distribution Chart
        PlDistributionChart(),

        SizedBox(height: 16),

        // Win/Loss by Symbol Chart
        WinLossBySymbolChart(),

        SizedBox(height: 16),

        // Win/Loss by Reason Chart
        WinLossByReasonChart(),

        SizedBox(height: 16),

        // Profit by Day Chart
        ProfitByDayChart(),

        SizedBox(height: 16),

        // Profit by Session Chart
        ProfitBySessionChart(),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Recent Trades Section
// ───────────────────────────────────────────────────────────────

class _RecentTradesSection extends StatelessWidget {
  final ColorScheme cs;
  final WidgetRef ref;

  const _RecentTradesSection({required this.cs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final tradesAsync = ref.watch(tradeListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Trades',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.go('/trades'),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        tradesAsync.when(
          data: (trades) {
            final recent = trades.take(3).toList();
            if (recent.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No trades yet. Tap "Add Trade" to get started.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return Column(
              children: recent.map((trade) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TradeCard(
                    position: trade,
                    compact: true,
                    onTap: () => context.push('/trades/${trade.id}'),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => Column(
            children: List.generate(3, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _shimmerCard(height: 72),
            )),
          ),
          error: (_, _) => Center(
            child: Text(
              'Could not load trades',
              style: GoogleFonts.inter(fontSize: 14, color: cs.error),
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Shimmer placeholders
// ───────────────────────────────────────────────────────────────

Widget _shimmerCard({double height = 100}) {
  return ShimmerPlaceholder.card(height: height);
}

Widget _shimmerText({required double width, required double height}) {
  return ShimmerPlaceholder.text(width: width, height: height);
}
