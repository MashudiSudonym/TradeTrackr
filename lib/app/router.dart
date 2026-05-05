import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/pages.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/onboarding_provider.dart';
import 'main_shell.dart';
import 'router_refresh_stream.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter provider — keepAlive because the router must persist.
///
/// Auth redirect checks authentication status and redirects:
/// - First-time users → /onboarding
/// - Unauthenticated users trying to access protected routes → /login
/// - Authenticated users trying to access /login or /register → /
///
/// Uses refreshListenable to re-evaluate redirects when auth or onboarding
/// state changes (e.g., after login, logout, or completing onboarding).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Create refresh notifiers for auth and onboarding state changes
  // They automatically listen to their respective providers
  final authRefresh = AuthRefreshNotifier(ref);
  final onboardingRefresh = OnboardingRefreshNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: Listenable.merge([authRefresh, onboardingRefresh]),
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check authentication and onboarding status
      final isAuthenticated = ref.watch(authStateProvider) != null;
      final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // If not completed onboarding and not on onboarding page, redirect to onboarding
      if (!hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }

      // If not authenticated and not on login/register/forgot-password page, redirect to login
      if (!isAuthenticated && !isOnboarding && !isLoggingIn) {
        return '/login';
      }

      // If authenticated and on login/register page, redirect to home
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Onboarding route — outside the shell (no bottom nav)
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingWrapperPage(),
      ),
      // Auth routes — outside the shell (no bottom nav)
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      // Password reset confirmation (accessed via deep link from email)
      GoRoute(
        path: '/reset-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      // Full-screen routes outside shell (accessed via context.push)
      GoRoute(
        path: '/import-export',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportExportPage(),
      ),
      GoRoute(
        path: '/recommendations',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RecommendationsPage(),
      ),
      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          // Branch 1: Trades
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trades',
                builder: (context, state) => const TradeListPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AddTradePage(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final tradeId = state.pathParameters['id']!;
                      return AddTradePage(tradeId: tradeId);
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final tradeId = state.pathParameters['id']!;
                      return TradeDetailPage(tradeId: tradeId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Finance
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/finance',
                builder: (context, state) => const FinancePage(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProfileEditPage(),
                  ),
                  GoRoute(
                    path: 'security',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ChangePasswordPage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
