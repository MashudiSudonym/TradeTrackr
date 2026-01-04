import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';

abstract interface class PreferencesRepository {
  Future<Result<PreferencesEntity>> getPreferences();

  Future<Result<void>> savePreferences({
    required PreferencesEntity preferencesEntity,
  });
}
