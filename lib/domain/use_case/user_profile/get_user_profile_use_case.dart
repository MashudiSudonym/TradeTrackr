import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/core/utils/use_case.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';

class GetUserProfileUseCase implements UseCase<Result<UserEntity>, void> {
  final UserRepository _userRepository;

  GetUserProfileUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Result<UserEntity>> call(void _) async {
    final profile = await _userRepository.getUser();

    if (profile.isSuccess) {
      return Result.success(profile.resultValue!);
    } else {
      return Result.failed(profile.errorMessage!);
    }
  }
}
