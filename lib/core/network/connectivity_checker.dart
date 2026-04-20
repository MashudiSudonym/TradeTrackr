import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity checker.
///
/// Monitors network status and provides online/offline state.
class ConnectivityChecker {
  final Connectivity _connectivity;

  ConnectivityChecker({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Stream of connectivity changes.
  ///
  /// Emits `true` when device is online, `false` when offline.
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.isNotEmpty &&
            (results.any((r) => r != ConnectivityResult.none)),
      );

  /// Check if device is currently online.
  ///
  /// Returns `true` if any network connection is available.
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        (results.any((r) => r != ConnectivityResult.none));
  }

  /// Check if device is currently offline.
  Future<bool> get isOffline async => !(await isOnline);
}
