import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  factory UserEntity({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, Object?> json) =>
      _$UserEntityFromJson(json);
}
