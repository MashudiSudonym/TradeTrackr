import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../providers/auth_provider.dart';

/// Navigation drawer widget for desktop layout.
///
/// Displayed as a permanent drawer on desktop devices (>=900px).
/// Features a header with user info and footer with additional actions.
class NavigationDrawerWidget extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const NavigationDrawerWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          right: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            // Header section with user info
            _DrawerHeader(
              userName: user?.displayName ?? 'Trader',
              userEmail: user?.email ?? '',
              isDark: isDark,
            ),

            const Divider(height: 1, color: AppColors.outlineVariant),

            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerNavItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _DrawerNavItem(
                    icon: Icons.analytics_outlined,
                    label: 'Trades',
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _DrawerNavItem(
                    icon: Icons.payments_outlined,
                    label: 'Finance',
                    isActive: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _DrawerNavItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.outlineVariant),

            // Footer with additional actions
            _DrawerFooter(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isDark;

  const _DrawerHeader({
    required this.userName,
    required this.userEmail,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar circle with initials
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(userName),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            userEmail,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'T';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class _DrawerNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    const inactiveColor = AppColors.onSurfaceVariant;

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? activeColor : inactiveColor,
        size: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? activeColor : inactiveColor,
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
      selected: isActive,
      selectedTileColor: activeColor.withValues(alpha: 0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  final bool isDark;

  const _DrawerFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () => GoRouter.of(context).push('/profile/settings'),
            icon: const Icon(Icons.settings_outlined, size: 20),
            label: const Text('Settings'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              alignment: Alignment.centerLeft,
            ),
          ),
          TextButton.icon(
            onPressed: () => GoRouter.of(context).push('/profile/settings'),
            icon: const Icon(Icons.help_outline, size: 20),
            label: const Text('Help & Support'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}
