import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/pages.dart';
import 'main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter provider — keepAlive because the router must persist.
///
/// Auth redirect is currently disabled (presentation-first development).
/// TODO: Integrate with authStateProvider when auth is implemented.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
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
    // Auth redirect — currently disabled for presentation-first development
    redirect: (context, state) {
      // TODO: Enable when auth is implemented
      return null;
    },
  );
});
