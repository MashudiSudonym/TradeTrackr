import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/data/repository/preferences_repository_impl.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';
import 'package:trade_trackr/presentation/provider/repository/preferences_repository/preferences_repository_provider.dart';

void main() {
  group('PreferencesRepositoryProvider', () {
    test('preferencesRepositoryProvider should return PreferencesRepositoryImpl instance', () {
      final container = ProviderContainer();

      final repository = container.read(preferencesRepositoryProvider);

      expect(repository, isA<PreferencesRepositoryImpl>());
      expect(repository, isA<PreferencesRepository>());

      container.dispose();
    });
  });
}