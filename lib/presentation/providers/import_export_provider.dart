import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/import_state.dart';

/// Manages import and export state for the Import/Export page.
///
/// Currently uses mock behavior with Future.delayed.
/// TODO: Replace with real CSV import/export logic when backend is integrated.
final importStateProvider =
    NotifierProvider<ImportStateNotifier, ImportState>(
  ImportStateNotifier.new,
);

class ImportStateNotifier extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState.idle();

  /// Simulates a CSV import with mock progress.
  Future<void> startMockImport() async {
    const total = 100;

    state = const ImportState.loading(processed: 0, total: total);

    for (var i = 0; i <= total; i += 10) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      state = ImportState.loading(processed: i, total: total);
    }

    state = const ImportState.success(
      imported: 92,
      skipped: 5,
      errors: 3,
    );
  }

  /// Resets import state back to idle.
  void reset() {
    state = const ImportState.idle();
  }
}
