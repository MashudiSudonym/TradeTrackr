import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/data/repository/user_repository_impl.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/presentation/provider/repository/user_repository/user_repository_provider.dart';

void main() {
  group('UserRepositoryProvider', () {
    test('userRepositoryProvider should return UserRepositoryImpl instance', () {
      final container = ProviderContainer();

      final repository = container.read(userRepositoryProvider);

      expect(repository, isA<UserRepositoryImpl>());
      expect(repository, isA<UserRepository>());

      container.dispose();
    });
  });
}