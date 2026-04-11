import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status_state.freezed.dart';

@freezed
abstract class SyncStatusState with _$SyncStatusState {
  const factory SyncStatusState.synced() = SyncStatusSynced;

  const factory SyncStatusState.syncing({
    @Default(0) int pushed,
    @Default(0) int total,
  }) = SyncStatusSyncing;

  const factory SyncStatusState.pending({
    required int pendingCount,
  }) = SyncStatusPending;

  const factory SyncStatusState.offline() = SyncStatusOffline;

  const factory SyncStatusState.error(String message) = SyncStatusError;
}
