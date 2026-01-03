import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/presentation/provider/use_case/get_preferences_use_case_provider.dart';
import 'package:trade_trackr/result.dart';

part 'preferences_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PreferencesEntity?> preferences(Ref ref) async {
  final getPreferencesUseCase = ref.read(getPreferencesUseCaseProvider);
  final result = await getPreferencesUseCase(null);

  if (result is Success<PreferencesEntity>) {
    return result.value;
  }
  return null;
}
