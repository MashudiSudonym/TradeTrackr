import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../state/import_state.dart';

part 'import_export_provider.g.dart';

/// Manages import and export state for the Import/Export page.
///
/// Currently uses mock behavior with Future.delayed.
/// TODO: Replace with real CSV import/export logic when backend is integrated.
@riverpod
class ImportExport extends _$ImportExport {
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
