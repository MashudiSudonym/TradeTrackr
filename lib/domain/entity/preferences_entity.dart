import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_entity.freezed.dart';
part 'preferences_entity.g.dart';

@freezed
abstract class PreferencesEntity with _$PreferencesEntity {
  factory PreferencesEntity({@Default(false) bool is24HourFormat}) =
      _PreferencesEntity;

  factory PreferencesEntity.fromJson(Map<String, Object?> json) =>
      _$PreferencesEntityFromJson(json);
}
