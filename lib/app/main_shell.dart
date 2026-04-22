import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/theme/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../presentation/widgets/navigation_drawer.dart';
import '../presentation/widgets/navigation_rail.dart';

/// Main shell widget wrapping all tabbed screens with adaptive navigation.
///
/// Navigation adapts based on screen size:
/// - Mobile (< 600px): Glassmorphism bottom navigation bar
/// - Tablet (600-899px): Navigation rail on the left
/// - Desktop (>= 900px): Permanent navigation drawer
///
/// Uses StatefulNavigationShell to preserve tab state when switching.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _handleTabTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Adaptive navigation based on screen size
    if (context.isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationDrawerWidget(
              currentIndex: navigationShell.currentIndex,
              onTap: _handleTabTap,
              isDark: isDark,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    if (context.isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRailWidget(
              currentIndex: navigationShell.currentIndex,
              onTap: _handleTabTap,
              isDark: isDark,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    // Mobile: bottom navigation bar
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _handleTabTap,
        isDark: isDark,
      ),
    );
  }
}

/// Glassmorphism bottom navigation bar with 4 tabs.
///
/// Design specs:
/// - Background: surface at 80% opacity with 20px backdrop blur
/// - Active: Crimson Heart icon (filled) + label + crimson pill bg
/// - Inactive: Muted Steel (#757c7d) icon + label
/// - Ghost border top at 15% opacity
/// - Icons MUST always have labels (clarity is the ultimate luxury)
class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _GlassBottomNav({
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
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabs.length, (index) {
                  final isActive = index == currentIndex;
                  return _NavTabItem(
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

class _NavTabItem extends StatelessWidget {
  final _NavTab tab;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.tab,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.activeIcon, color: activeColor, size: 24),
              const SizedBox(height: 2),
              Text(
                tab.label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, color: inactiveColor, size: 24),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                color: inactiveColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
