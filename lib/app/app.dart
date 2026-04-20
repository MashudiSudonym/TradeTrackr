import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/theme_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root application widget.
///
/// Watches themeProvider for theme mode and goRouterProvider for routing.
class TradeTrackrApp extends ConsumerWidget {
  const TradeTrackrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'TradeTrackr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
