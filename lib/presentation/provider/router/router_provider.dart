import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_trackr/presentation/page/main_page/main_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/presentation/page/onboarding/onboarding_page.dart';
import 'package:trade_trackr/presentation/page/register/register_page.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) => GoRouter(
  routes: [
    GoRoute(
      path: '/main',
      name: 'main',
      builder: (BuildContext context, GoRouterState state) => const MainPage(),
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
);
