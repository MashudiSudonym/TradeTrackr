import 'package:workmanager/workmanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tradetrackr/presentation/providers/sync_provider.dart';

/// Workmanager callback dispatcher for background sync tasks.
///
/// This function is called by the OS when the periodic sync task is triggered.
/// It initializes Flutter and executes the sync operation.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize a ProviderContainer to access providers
    final container = ProviderContainer();

    try {
      // Get the sync engine
      final syncEngine = container.read(syncEngineProvider);

      // Perform both push and pull sync
      await syncEngine.pushUnsyncedRecords();
      await syncEngine.pullRemoteChanges();

      return Future.value(true);
    } catch (e) {
      // Log error but don't fail - workmanager will retry
      return Future.value(true);
    } finally {
      container.dispose();
    }
  });
}
