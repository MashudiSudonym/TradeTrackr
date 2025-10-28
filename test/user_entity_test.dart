import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should create UserEntity from JSON', () {
      final json = {
        'id': '1',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
      };

      final user = UserEntity.fromJson(json);

      expect(user.id, '1');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(user.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('should convert UserEntity to JSON', () {
      final user = UserEntity(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Doe');
      expect(json['email'], 'john.doe@example.com');
      expect(json['createdAt'], '2023-01-01T00:00:00.000Z');
      expect(json['updatedAt'], '2023-01-02T00:00:00.000Z');
    });

    test('should handle null email and updatedAt', () {
      final json = {
        'id': '1',
        'firstName': 'John',
        'lastName': 'Doe',
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      final user = UserEntity.fromJson(json);

      expect(user.email, isNull);
      expect(user.updatedAt, isNull);
    });
  });
}