import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/import_export_provider.dart';
import '../state/import_state.dart';

/// Shows import progress using [ImportState] Freezed union.
///
/// - idle: "Select a CSV file to import"
/// - loading: LinearProgressIndicator + "Processing row X of Y"
/// - success: green check + "Imported: N, Skipped: N, Errors: N"
/// - error: red error icon + error message
class ImportProgressIndicator extends ConsumerWidget {
  const ImportProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importStateProvider);
    final cs = Theme.of(context).colorScheme;

    return importState.when(
      idle: () => _IdleState(cs: cs),
      loading: (processed, total) => _LoadingState(
        cs: cs,
        processed: processed,
        total: total,
      ),
      success: (imported, skipped, errors) => _SuccessState(
        cs: cs,
        imported: imported,
        skipped: skipped,
        errors: errors,
      ),
      error: (message) => _ErrorState(cs: cs, message: message),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// State Widgets
// ───────────────────────────────────────────────────────────────

class _IdleState extends StatelessWidget {
  final ColorScheme cs;

  const _IdleState({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Select a CSV file to import',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final ColorScheme cs;
  final int processed;
  final int total;

  const _LoadingState({
    required this.cs,
    required this.processed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? processed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Processing row $processed of $total',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final ColorScheme cs;
  final int imported;
  final int skipped;
  final int errors;

  const _SuccessState({
    required this.cs,
    required this.imported,
    required this.skipped,
    required this.errors,
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
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.check_circle, size: 20, color: cs.tertiary),
              const SizedBox(width: 12),
              Text(
                'Import Complete',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              _StatChip(
                label: 'Imported',
                value: imported,
                color: cs.tertiary,
              ),
              const SizedBox(width: 12),
              _StatChip(
                label: 'Skipped',
                value: skipped,
                color: cs.outline,
              ),
              const SizedBox(width: 12),
              _StatChip(
                label: 'Errors',
                value: errors,
                color: cs.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final ColorScheme cs;
  final String message;

  const _ErrorState({required this.cs, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 20, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cs.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Helper Widgets
// ───────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
