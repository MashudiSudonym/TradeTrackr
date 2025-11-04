import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_params.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/save_preferences_use_case_provider.dart';

part 'preferences_setup.g.dart';

@riverpod
Future<void> preferencesSetup(Ref ref, {required bool is24HourFormat}) async {
  SavePreferencesUseCase savePreferencesUseCase = ref.read(
    savePreferencesUseCaseProvider,
  );

  var result = await savePreferencesUseCase(
    SavePreferencesParams(is24HourFormat: is24HourFormat),
  );

  return switch (result) {
    Success(value: final pref) => pref,
    Failed(message: _) => null,
  };
}
