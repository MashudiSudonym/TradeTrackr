import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_use_case.dart';
import 'package:trade_trackr/presentation/provider/repository/preferences_repository/preferences_repository_provider.dart';

part 'save_preferences_use_case_provider.g.dart';

@riverpod
SavePreferencesUseCase savePreferencesUseCase(Ref ref) =>
    SavePreferencesUseCase(
      preferencesRepository: ref.watch(preferencesRepositoryProvider),
    );
