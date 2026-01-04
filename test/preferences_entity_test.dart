import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';

void main() {
  group('PreferencesEntity', () {
    test('should create PreferencesEntity from JSON', () {
      final json = {
        'is24HourFormat': true,
      };

      final preferences = PreferencesEntity.fromJson(json);

      expect(preferences.is24HourFormat, true);
    });

    test('should convert PreferencesEntity to JSON', () {
      final preferences = PreferencesEntity(is24HourFormat: true);

      final json = preferences.toJson();

      expect(json['is24HourFormat'], true);
    });

    test('should use default value when is24HourFormat is not provided', () {
      final json = <String, Object?>{};

      final preferences = PreferencesEntity.fromJson(json);

      expect(preferences.is24HourFormat, false);
    });
  });
}