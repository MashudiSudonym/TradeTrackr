import 'package:flutter/material.dart';

/// Pagination bar with item count and page navigation buttons.
///
/// Left side shows italic count text (e.g., "42 trades").
/// Right side has circular prev/next arrow buttons and page indicator.
class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final canGoBack = currentPage > 1;
    final canGoForward = currentPage < totalPages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Count text (italic)
        Text(
          '$totalItems trades',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
        // Page buttons
        Row(
          children: [
            // Previous button
            _PageButton(
              icon: Icons.chevron_left,
              isEnabled: canGoBack,
              onTap: canGoBack ? () => onPageChanged(currentPage - 1) : null,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 8),
            // Page indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$currentPage / $totalPages',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Next button
            _PageButton(
              icon: Icons.chevron_right,
              isEnabled: canGoForward,
              onTap:
                  canGoForward ? () => onPageChanged(currentPage + 1) : null,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled
              ? colorScheme.surfaceContainerHigh
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled
              ? colorScheme.onSurface
              : colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
