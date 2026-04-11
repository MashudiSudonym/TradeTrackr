import 'package:flutter/material.dart';

import '../../domain/enums/close_reason.dart';

/// Pill-shaped badge showing the close reason and win/loss status.
///
/// Displays an icon and reason description with success/error container
/// background based on the trade outcome.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.reason,
    required this.isWin,
  });

  final CloseReason reason;
  final bool isWin;

  IconData get _icon => switch (reason) {
        CloseReason.tp => Icons.verified_outlined,
        CloseReason.sl => Icons.warning_amber_outlined,
        CloseReason.user => Icons.person_outline,
        CloseReason.manual => Icons.edit_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor =
        isWin ? colorScheme.tertiaryContainer : colorScheme.errorContainer;
    final textColor = isWin
        ? colorScheme.onTertiaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            reason.description,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
