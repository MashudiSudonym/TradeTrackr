import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/pages.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/onboarding_provider.dart';
import 'main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter provider — keepAlive because the router must persist.
///
/// Auth redirect checks authentication status and redirects:
/// - First-time users → /onboarding
/// - Unauthenticated users trying to access protected routes → /login
/// - Authenticated users trying to access /login or /register → /
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check authentication and onboarding status
      final isAuthenticated = ref.read(authStateProvider) != null;
      final hasCompletedOnboarding = ref.read(hasCompletedOnboardingProvider);
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
