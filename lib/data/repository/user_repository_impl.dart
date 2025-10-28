import 'package:drift/drift.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase db;

  UserRepositoryImpl(this.db);

  @override
  Future<Result<UserEntity>> getUser() async {
    final userRow = await db.select(db.userTable).getSingleOrNull();

    if (userRow != null) {
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
      return Result.failed('User not found!');
    }
  }

  @override
  Future<Result<UserEntity>> saveUser({required UserEntity userEntity}) async {
    try {
      await db
          .into(db.userTable)
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

      final userRow = await (db.select(
        db.userTable,
      )..where((tbl) => tbl.id.equals(userEntity.id))).getSingleOrNull();

      if (userRow != null) {
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
        return Result.failed('Error failed to save data!');
      }
    } catch (e) {
      return Result.failed(e.toString());
    }
  }
}
