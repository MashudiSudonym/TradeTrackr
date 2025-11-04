import 'package:drift/drift.dart';
import 'package:trade_trackr/core/constants/constants.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase _db;

  UserRepositoryImpl({AppDatabase? db}) : _db = db ?? AppDatabase();

  /// Since the user is offline and this method always returns a single user data,
  /// there is no need to include a user ID as a query parameter for getUser.
  @override
  Future<Result<UserEntity>> getUser() async {
    try {
      final userRow = await _db.select(_db.userTable).getSingleOrNull();

      if (userRow != null) {
        Constants.logger.d('success');

        return Result.success(
          UserEntity(
            id: userRow.id,
            firstName: userRow.firstName,
            lastName: userRow.lastName,
            email: userRow.email,
            createdAt: userRow.createdAt,
            updatedAt: userRow.updatedAt,
          ),
        );
      } else {
        Constants.logger.e('User not found!');
        return Result.failed('User not found!');
      }
    } catch (e) {
      Constants.logger.e('Failed to get user: $e');
      return Result.failed('Failed to retrieve user data!');
    }
  }

  @override
  Future<Result<void>> saveUser({required UserEntity userEntity}) async {
    try {
      await _db
          .into(_db.userTable)
          .insertOnConflictUpdate(
            UserTableCompanion(
              id: Value(userEntity.id),
              firstName: Value(userEntity.firstName),
              lastName: Value(userEntity.lastName),
              email: Value(userEntity.email),
              createdAt: Value(userEntity.createdAt),
              updatedAt: Value(userEntity.updatedAt),
            ),
          );

      Constants.logger.d('success');

      return Result.success(null);
    } catch (e) {
      Constants.logger.e('Failed to save user: $e');
      return Result.failed(e.toString());
    }
  }
}
