import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';

abstract interface class UserRepository {
  Future<Result<UserEntity>> getUser();
  Future<Result<void>> saveUser({required UserEntity userEntity});
}
