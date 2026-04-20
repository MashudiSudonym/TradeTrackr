import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Freezed DTO for user.
///
/// Used for serialization to/from Supabase.
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String email,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Convert to domain entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert from domain entity.
  factory UserDto.fromEntity(User entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to JSON map for Supabase.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
