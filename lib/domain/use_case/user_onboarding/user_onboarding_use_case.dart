import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/core/utils/use_case.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:uuid/uuid.dart';

class UserOnboardingUseCase
    implements UseCase<Result<UserEntity>, UserOnboardingParams> {
  final UserRepository _userRepository;
  final Uuid _uuid = Uuid();

  UserOnboardingUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Result<UserEntity>> call(UserOnboardingParams params) async {
    final saveUser = await _userRepository.saveUser(
      userEntity: UserEntity(
        id: _uuid.v4(),
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (saveUser.isSuccess) {
      return Result.success(saveUser.resultValue!);
    } else {
      return Result.failed(saveUser.errorMessage ?? 'failed to process!');
    }
  }
}
