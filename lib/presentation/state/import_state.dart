import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_state.freezed.dart';

@freezed
abstract class ImportState with _$ImportState {
  const factory ImportState.idle() = ImportIdle;

  const factory ImportState.loading({
    @Default(0) int processed,
    @Default(0) int total,
  }) = ImportLoading;

  const factory ImportState.success({
    required int imported,
    required int skipped,
    required int errors,
  }) = ImportSuccess;

  const factory ImportState.error(String message) = ImportError;
}
