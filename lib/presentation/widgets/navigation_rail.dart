import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Navigation rail widget for tablet layout.
///
/// Displayed on the left side of the screen on tablet devices (600-900px).
/// Uses glassmorphism effect similar to bottom navigation bar.
class NavigationRailWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const NavigationRailWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  static const _tabs = [
    _NavTab(icon: Icons.dashboard, activeIcon: Icons.dashboard, label: 'Dashboard'),
    _NavTab(icon: Icons.analytics_outlined, activeIcon: Icons.analytics, label: 'Trades'),
    _NavTab(icon: Icons.payments_outlined, activeIcon: Icons.payments, label: 'Finance'),
    _NavTab(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    const inactiveColor = AppColors.outline;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: 0.8),
            border: Border(
              right: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: SafeArea(
            right: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_tabs.length, (index) {
                  final isActive = index == currentIndex;
                  return _RailTabItem(
                    tab: _tabs[index],
                    isActive: isActive,
                    activeColor: AppColors.primary,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(index),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailTabItem extends StatelessWidget {
  final _NavTab tab;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _RailTabItem({
    required this.tab,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? activeColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? tab.activeIcon : tab.icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
