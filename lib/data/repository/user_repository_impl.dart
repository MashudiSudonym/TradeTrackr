import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Result<UserEntity>> getUser({required String id}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Result<UserEntity>> saveUser({required UserEntity userEntity}) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
