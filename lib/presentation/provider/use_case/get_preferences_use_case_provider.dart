import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/get_preferences_use_case.dart';
import 'package:trade_trackr/presentation/provider/repository/preferences_repository/preferences_repository_provider.dart';

part 'get_preferences_use_case_provider.g.dart';

@riverpod
GetPreferencesUseCase getPreferencesUseCase(Ref ref) => GetPreferencesUseCase(
  preferencesRepository: ref.watch(preferencesRepositoryProvider),
);
