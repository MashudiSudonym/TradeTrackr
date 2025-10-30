import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/core/utils/use_case.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';

class GetPreferencesUseCase
    implements UseCase<Result<PreferencesEntity>, void> {
  final PreferencesRepository _preferencesRepository;

  GetPreferencesUseCase({required PreferencesRepository preferencesRepository})
    : _preferencesRepository = preferencesRepository;

  @override
  Future<Result<PreferencesEntity>> call(void _) async {
    final pref = await _preferencesRepository.getPreferences();

    if (pref.isSuccess) {
      return Result.success(pref.resultValue!);
    } else {
      return Result.failed(pref.errorMessage ?? 'failed to process!');
    }
  }
}
