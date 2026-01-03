import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_trackr/presentation/page/main_page/main_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/presentation/page/onboarding/onboarding_page.dart';
import 'package:trade_trackr/presentation/page/register/register_page.dart';
import 'package:trade_trackr/presentation/provider/preferences/preferences_provider.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) {
  final preferencesAsync = ref.watch(preferencesProvider);

  return GoRouter(
    routes: [
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (BuildContext context, GoRouterState state) =>
            const MainPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
    ],
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final preferences = preferencesAsync.value;

      // While loading preferences, don't redirect
      if (preferencesAsync.isLoading) return null;

      final isRegistered = preferences?.isRegistered ?? false;
      final loggingIn =
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/register';

      if (isRegistered) {
        if (loggingIn) return '/main';
      } else {
        if (!loggingIn) return '/onboarding';
      }

      return null;
    },
  );
}
