import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/import_export_provider.dart';
import '../state/import_state.dart';
import '../widgets/import_progress_indicator.dart';
import '../widgets/pill_toggle.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_label.dart';

/// Import/Export page with segmented control for CSV operations.
///
/// Follows the "Curated Ledger" design system:
/// - Surface backgrounds with tonal layering
/// - 12px card radius, no borders/shadows
/// - Inter/Manrope typography, ALL CAPS labels
class ImportExportPage extends ConsumerStatefulWidget {
  const ImportExportPage({super.key});

  @override
  ConsumerState<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends ConsumerState<ImportExportPage> {
  _Tab _selectedTab = _Tab.import;

  // Export checkboxes
  bool _exportClosed = true;
  bool _exportOpen = false;
  bool _exportFinance = false;
  bool _allTime = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top App Bar ──────────────────────────────────
          _buildTopBar(cs),

          // ── Segmented Control ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PillToggle<_Tab>(
              options: const [
                PillOption(value: _Tab.import, label: 'Import'),
                PillOption(value: _Tab.export, label: 'Export'),
              ],
              selected: _selectedTab,
              onChanged: (tab) => setState(() => _selectedTab = tab),
            ),
          ),

          const SizedBox(height: 24),

          // ── Content ──────────────────────────────────────
          Expanded(
            child: _selectedTab == _Tab.import
                ? _buildImportTab(cs)
                : _buildExportTab(cs),
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
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: cs.onSurface, size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Text(
              'Import / Export',
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

  // ── Import Tab ─────────────────────────────────────────────

  Widget _buildImportTab(ColorScheme cs) {
    final importState = ref.watch(importStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const SectionLabel(label: 'IMPORT CSV'),
          Text(
            'Import trade data from CSV files',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cs.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // Supported formats card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPPORTED FORMATS',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _FormatRow(cs: cs, text: 'Closed Positions: CLOSED_POSITIONS_*.csv'),
                const SizedBox(height: 8),
                _FormatRow(cs: cs, text: 'Open Positions: OPEN_POSITIONS_*.csv'),
                const SizedBox(height: 8),
                _FormatRow(cs: cs, text: 'Finance Records: FINANCE_*.csv'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Select File button
          PrimaryButton(
            label: 'Select File',
            icon: Icons.upload_file,
            onPressed: importState is ImportLoading
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'CSV import will be available when backend is integrated',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
          ),

          const SizedBox(height: 20),

          // Progress indicator
          const ImportProgressIndicator(),
        ],
      ),
    );
  }

  // ── Export Tab ─────────────────────────────────────────────

  Widget _buildExportTab(ColorScheme cs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const SectionLabel(label: 'EXPORT CSV'),
          Text(
            'Export your trade data to CSV files',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cs.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // Export type checkboxes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPORT TYPES',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _CheckboxRow(
                  cs: cs,
                  label: 'Closed Positions',
                  value: _exportClosed,
                  onChanged: (v) => setState(() => _exportClosed = v),
                ),
                const SizedBox(height: 8),
                _CheckboxRow(
                  cs: cs,
                  label: 'Open Positions',
                  value: _exportOpen,
                  onChanged: (v) => setState(() => _exportOpen = v),
                ),
                const SizedBox(height: 8),
                _CheckboxRow(
                  cs: cs,
                  label: 'Finance Records',
                  value: _exportFinance,
                  onChanged: (v) => setState(() => _exportFinance = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Date range selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DATE RANGE',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _allTime ? 'All Time' : 'Custom Range',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _allTime,
                  onChanged: (v) => setState(() => _allTime = v),
                  activeThumbColor: cs.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Export button
          PrimaryButton(
            label: 'Export',
            icon: Icons.download,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'CSV export will be available when backend is integrated',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// Helper Widgets
// ───────────────────────────────────────────────────────────────

enum _Tab { import, export }

class _FormatRow extends StatelessWidget {
  final ColorScheme cs;
  final String text;

  const _FormatRow({required this.cs, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.description_outlined, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  final ColorScheme cs;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckboxRow({
    required this.cs,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
