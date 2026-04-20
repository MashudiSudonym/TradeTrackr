import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/recommendation.dart';
import '../../domain/enums/severity.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/section_label.dart';

/// Recommendations page showing trading insights grouped by severity.
///
/// Follows the "Curated Ledger" design system:
/// - Surface backgrounds with tonal layering
/// - 12px card radius, no borders/shadows
/// - Inter/Manrope typography, ALL CAPS labels
class RecommendationsPage extends ConsumerWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top App Bar ──────────────────────────────────
          _TopBar(cs: cs),

          // ── Content ──────────────────────────────────────
          Expanded(
            child: ref.watch(recommendationsProvider).when(
                  data: (recommendations) =>
                      _Content(cs: cs, recommendations: recommendations),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, _) => Center(
                    child: Text(
                      'Could not load recommendations',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: cs.error,
                      ),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Top Bar (needs BuildContext for go_router)
// ───────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final ColorScheme cs;

  const _TopBar({required this.cs});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: cs.onSurface, size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Text(
              'Recommendations',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Content Area
// ───────────────────────────────────────────────────────────────

class _Content extends StatelessWidget {
  final ColorScheme cs;
  final List<Recommendation> recommendations;

  const _Content({required this.cs, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 48,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No recommendations yet',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start trading to get personalized insights!',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Group by severity: critical first, then warning, then info
    final critical = recommendations
        .where((r) => r.severity == Severity.critical)
        .toList();
    final warning = recommendations
        .where((r) => r.severity == Severity.warning)
        .toList();
    final info =
        recommendations.where((r) => r.severity == Severity.info).toList();

    final sorted = [...critical, ...warning, ...info];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          const SectionLabel(label: 'TRADING INSIGHTS'),
          Text(
            'Based on your trading history, here are personalized recommendations',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cs.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // Recommendation cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return RecommendationCard(
                recommendation: sorted[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
