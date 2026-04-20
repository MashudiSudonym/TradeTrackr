import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_result_dto.freezed.dart';

/// Freezed DTO for import result.
///
/// Used to return CSV import statistics.
@freezed
abstract class ImportResultDto with _$ImportResultDto {
  const ImportResultDto._();

  const factory ImportResultDto({
    required int imported,
    @Default(0) int skipped,
    @Default(0) int errors,
    @Default(<String>[]) List<String> errorMessages,
  }) = _ImportResultDto;

  /// Whether the import had any errors.
  bool get hasErrors => errors > 0;

  /// Total number of rows processed.
  int get totalProcessed => imported + skipped + errors;
}
