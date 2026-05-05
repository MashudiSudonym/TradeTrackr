import 'dart:async';
import 'dart:io' show Platform;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/network/connectivity_checker.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/logger/app_logger.dart';
import 'di_providers.dart';

part 'sync_provider.g.dart';

/// Provides the connectivity checker instance.
///
/// KeepAlive: true - connectivity checker must persist across navigation.
@Riverpod(keepAlive: true)
ConnectivityChecker connectivityChecker(Ref ref) {
  return ConnectivityChecker();
}

/// Provides the sync engine with all required dependencies.
///
/// KeepAlive: true - sync engine must persist for background operations.
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final localSource = ref.watch(tradeLocalDataSourceProvider);
  final remoteSource = ref.watch(tradeRemoteDataSourceProvider);
  final connectivity = ref.watch(connectivityCheckerProvider);

  return SyncEngine(
    localSource: localSource,
    remoteSource: remoteSource,
    connectivity: connectivity,
  );
}

/// Sync controller - manages sync lifecycle and triggers.
///
/// Handles:
/// - Initial sync after login
/// - Connectivity-based sync (push when online)
/// - Periodic background sync via workmanager
/// - App lifecycle sync (on resume)
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  Future<void> build() async {
    // Initialize workmanager and setup listeners
    await _initializeWorkmanager();
    _listenToConnectivity();

    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });
  }

  /// Initialize workmanager and register periodic sync task.
  Future<void> _initializeWorkmanager() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      // Register periodic sync task (Android minimum: 15 minutes)
      await Workmanager().registerPeriodicTask(
        'periodicSyncTask',
        'periodicSync',
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );

      appLogger.i('Workmanager periodic sync task registered');
    } catch (e) {
      appLogger.e('Failed to register workmanager task: $e');
    }
  }

  /// Listen to connectivity changes and trigger push when coming online.
  void _listenToConnectivity() {
    final connectivity = ref.read(connectivityCheckerProvider);

    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (isOnline) {
        if (isOnline) {
          appLogger.i('Connectivity restored, triggering push sync');
          pushSync();
        }
      },
    );
  }

  /// Perform initial sync (pull) after user login.
  ///
  /// This should be called immediately after successful authentication
  /// to ensure the local database is up-to-date with remote data.
  Future<void> performInitialSync() async {
    final syncEngine = ref.read(syncEngineProvider);

    try {
      appLogger.i('Starting initial sync (pull only)');
      await syncEngine.pullRemoteChanges();
      appLogger.i('Initial sync completed');
    } catch (e) {
      appLogger.e('Initial sync failed: $e');
      rethrow;
    }
  }

  /// Perform periodic background sync (push + pull).
  ///
  /// Called by workmanager callback dispatcher.
  Future<void> performPeriodicSync() async {
    final syncEngine = ref.read(syncEngineProvider);

    try {
      appLogger.i('Starting periodic sync');

      // Push unsynced records first
      await syncEngine.pushUnsyncedRecords();

      // Then pull remote changes
      await syncEngine.pullRemoteChanges();

      appLogger.i('Periodic sync completed');
    } catch (e) {
      appLogger.e('Periodic sync failed: $e');
    }
  }

  /// Push unsynced records to remote (called when connectivity restored).
  Future<void> pushSync() async {
    final syncEngine = ref.read(syncEngineProvider);

    try {
      await syncEngine.pushUnsyncedRecords();
    } catch (e) {
      appLogger.e('Push sync failed: $e');
    }
  }

  /// Pull remote changes (called when app resumes).
  Future<void> pullSync() async {
    final syncEngine = ref.read(syncEngineProvider);

    try {
      await syncEngine.pullRemoteChanges();
    } catch (e) {
      appLogger.e('Pull sync failed: $e');
    }
  }

  /// Sync on app resume (both push and pull).
  ///
  /// Called when app returns from background to ensure data is up-to-date.
  Future<void> syncOnResume() async {
    final connectivity = ref.read(connectivityCheckerProvider);

    // Only sync if we have connectivity
    if (await connectivity.isOnline) {
      try {
        appLogger.i('App resumed, starting sync');
        await performPeriodicSync();
      } catch (e) {
        appLogger.e('Resume sync failed: $e');
      }
    }
  }
}
