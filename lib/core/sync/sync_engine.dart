import '../network/connectivity_checker.dart';
import '../../data/datasources/trade_local_data_source.dart';
import '../../data/datasources/trade_remote_data_source.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sync status for offline-first sync engine.
enum SyncStatus {
  synced,
  pushing,
  pulling,
  pending,
  offline,
  error,
}

/// Offline-first sync engine.
///
/// Bridges local Drift database with remote Supabase.
/// Pushes unsynced records when online, pulls remote changes on demand.
class SyncEngine {
  final TradeLocalDataSource _localSource;
  final TradeRemoteDataSource _remoteSource;
  final ConnectivityChecker _connectivity;
  final Logger _logger;

  SyncEngine({
    required TradeLocalDataSource localSource,
    required TradeRemoteDataSource remoteSource,
    required ConnectivityChecker connectivity,
    Logger? logger,
  })  : _localSource = localSource,
        _remoteSource = remoteSource,
        _connectivity = connectivity,
        _logger = logger ?? Logger();

  /// Stream of sync status changes.
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  final _syncStatusController = StreamController<SyncStatus>.broadcast();

  /// Current sync status.
  SyncStatus _currentStatus = SyncStatus.offline;
  SyncStatus get currentStatus => _currentStatus;

  /// Get the current authenticated user ID from Supabase auth.
  String? get _currentUserId {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }

  /// Push all unsynced records to Supabase.
  Future<void> pushUnsyncedRecords() async {
    final userId = _currentUserId;
    if (userId == null) {
      _logger.w('No authenticated user - skipping push');
      return;
    }

    if (!await _connectivity.isOnline) {
      _logger.i('Offline - skipping push');
      _syncStatusController.add(SyncStatus.offline);
      _currentStatus = SyncStatus.offline;
      return;
    }

    _syncStatusController.add(SyncStatus.pushing);
    _currentStatus = SyncStatus.pushing;

    try {
      // Push closed positions
      final unsyncedClosed = await _localSource.getUnsyncedClosedPositions(userId);
      for (final data in unsyncedClosed) {
        await _remoteSource.upsertClosedPosition(data);
        await _localSource.markAsSynced(data['id'] as String, 'closed_positions');
      }

      // Push open positions
      final unsyncedOpen = await _localSource.getUnsyncedOpenPositions(userId);
      for (final data in unsyncedOpen) {
        await _remoteSource.upsertOpenPosition(data);
        await _localSource.markAsSynced(data['id'] as String, 'open_positions');
      }

      // Push finance records
      final unsyncedFinance = await _localSource.getUnsyncedFinanceRecords(userId);
      for (final data in unsyncedFinance) {
        await _remoteSource.upsertFinanceRecord(data);
        await _localSource.markAsSynced(data['id'] as String, 'finance_records');
      }

      _syncStatusController.add(SyncStatus.synced);
      _currentStatus = SyncStatus.synced;
      _logger.i('Push completed: ${unsyncedClosed.length + unsyncedOpen.length + unsyncedFinance.length} records');
    } catch (e) {
      _logger.e('Push failed: $e');
      _syncStatusController.add(SyncStatus.error);
      _currentStatus = SyncStatus.error;
    }
  }

  /// Pull all user data from Supabase into Drift.
  Future<void> pullRemoteChanges() async {
    final userId = _currentUserId;
    if (userId == null) {
      _logger.w('No authenticated user - skipping pull');
      return;
    }

    if (!await _connectivity.isOnline) {
      _logger.i('Offline - skipping pull');
      return;
    }

    _syncStatusController.add(SyncStatus.pulling);
    _currentStatus = SyncStatus.pulling;

    try {
      final remoteClosed = await _remoteSource.getClosedPositions(userId);
      final remoteOpen = await _remoteSource.getOpenPositions(userId);
      final remoteFinance = await _remoteSource.getFinanceRecords(userId);

      await _localSource.mergeClosedPositions(remoteClosed);
      await _localSource.mergeOpenPositions(remoteOpen);
      await _localSource.mergeFinanceRecords(remoteFinance);

      _syncStatusController.add(SyncStatus.synced);
      _currentStatus = SyncStatus.synced;
      _logger.i('Pull completed: ${remoteClosed.length + remoteOpen.length + remoteFinance.length} records');
    } catch (e) {
      _logger.e('Pull failed: $e');
      _syncStatusController.add(SyncStatus.error);
      _currentStatus = SyncStatus.error;
    }
  }

  /// Get count of unsynced records.
  Future<int> getUnsyncedCount() async {
    final userId = _currentUserId;
    if (userId == null) return 0;

    final closed = await _localSource.getUnsyncedClosedPositions(userId);
    final open = await _localSource.getUnsyncedOpenPositions(userId);
    final finance = await _localSource.getUnsyncedFinanceRecords(userId);

    return closed.length + open.length + finance.length;
  }

  /// Dispose the sync engine.
  void dispose() {
    _syncStatusController.close();
  }
}
