import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_params.dart';

class SavePreferencesUseCase
    implements UseCase<Result<void>, SavePreferencesParams> {
  final PreferencesRepository _preferencesRepository;

  SavePreferencesUseCase({required PreferencesRepository preferencesRepository})
    : _preferencesRepository = preferencesRepository;

  @override
  Future<Result<void>> call(SavePreferencesParams params) async {
    return await _preferencesRepository.savePreferences(
      preferencesEntity: PreferencesEntity(
        is24HourFormat: params.is24HourFormat,
        isRegistered: params.isRegistered,
      ),
    );
  }
}
