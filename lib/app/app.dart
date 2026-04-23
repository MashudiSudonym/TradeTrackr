import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/providers/theme_provider.dart';
import '../presentation/providers/di_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

part 'app.g.dart';

/// Root application widget with app lifecycle observation for sync.
///
/// Watches themeProvider for theme mode, goRouterProvider for routing,
/// and observes app lifecycle to trigger sync on resume.
@Riverpod(keepAlive: true)
class TradeTrackrAppState extends _$TradeTrackrAppState {
  @override
  void build() {
    // No state needed, just observer registration
  }

  /// Handle app lifecycle state changes.
  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Trigger sync when app resumes from background
      // This ensures data is up-to-date when user returns to app
      performSyncOnResume();
    }
  }

  /// Perform sync on app resume (both push and pull).
  Future<void> performSyncOnResume() async {
    try {
      await ref.read(syncControllerProvider.notifier).syncOnResume();
    } catch (e) {
      // Sync failures are logged inside syncController, no action needed here
      // Resume should not be blocked by sync failures
    }
  }
}

class TradeTrackrApp extends ConsumerStatefulWidget {
  const TradeTrackrApp({super.key});

  @override
  ConsumerState<TradeTrackrApp> createState() => _TradeTrackrAppState();
}

class _TradeTrackrAppState extends ConsumerState<TradeTrackrApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Delegate lifecycle changes to the state provider
    ref.read(tradeTrackrAppStateProvider.notifier).handleAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
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
