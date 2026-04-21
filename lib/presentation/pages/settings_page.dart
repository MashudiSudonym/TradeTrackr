import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/theme_provider.dart' as providers;
import '../providers/auth_provider.dart';
import '../widgets/theme_toggle.dart';

/// Settings page with theme toggle, navigation cards, and logout.
///
/// Follows the "Curated Ledger" design system:
/// - Surface backgrounds with tonal layering
/// - 12px card radius, no borders/shadows
/// - Inter/Manrope typography, ALL CAPS labels
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top App Bar ──────────────────────────────────
            _buildTopBar(cs, context),

            // ── Settings Section ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionLabel(cs, 'SETTINGS'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSettingsCards(cs, ref, context),
            ),

            const SizedBox(height: 32),

            // ── Account Section ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionLabel(cs, 'ACCOUNT'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLogoutButton(cs, ref, context),
            ),

            const SizedBox(height: 32),

            // ── App Version ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'TradeTrackr v1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ColorScheme cs, BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            Icon(Icons.auto_graph, size: 24, color: cs.primary),
            const SizedBox(width: 8),
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
              onPressed: () => context.pop(),
              icon: Icon(Icons.close, color: cs.onSurfaceVariant, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(ColorScheme cs, String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: cs.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSettingsCards(
      ColorScheme cs, WidgetRef ref, BuildContext context) {
    final themeMode = ref.watch(providers.themeProvider);

    return Column(
      children: [
        // Theme card with toggle
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.palette_outlined, size: 24, color: cs.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      themeMode == ThemeMode.dark
                          ? 'Dark mode'
                          : themeMode == ThemeMode.light
                              ? 'Light mode'
                              : 'System',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const ThemeToggle(),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Import/Export card
        _SettingsNavCard(
          cs: cs,
          icon: Icons.swap_horiz,
          title: 'Import / Export',
          subtitle: 'CSV data management',
          onTap: () => context.push('/import-export'),
        ),
        const SizedBox(height: 12),

        // Recommendations card
        _SettingsNavCard(
          cs: cs,
          icon: Icons.lightbulb_outline,
          title: 'Recommendations',
          subtitle: 'Trading insights',
          onTap: () => context.push('/recommendations'),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(ColorScheme cs, WidgetRef ref, BuildContext context) {
    return GestureDetector(
      onTap: () => _handleLogout(ref, context, cs),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: cs.error, width: 1.5),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Center(
          child: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.error,
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout(WidgetRef ref, BuildContext context, ColorScheme cs) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: cs.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              dialogContext.pop();
              // Perform logout - router will auto-redirect via refreshListenable
              ref.read(authProvider.notifier).logout();

              // Show confirmation
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
// Settings Navigation Card
// ───────────────────────────────────────────────────────────────

class _SettingsNavCard extends StatelessWidget {
  final ColorScheme cs;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsNavCard({
    required this.cs,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
