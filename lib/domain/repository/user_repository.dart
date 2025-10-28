import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';

abstract interface class UserRepository {
  Future<Result<UserEntity>> getUser();
  Future<Result<UserEntity>> saveUser({required UserEntity userEntity});
}
