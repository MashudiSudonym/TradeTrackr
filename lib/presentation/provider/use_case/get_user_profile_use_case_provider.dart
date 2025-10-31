import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/user_profile/get_user_profile_use_case.dart';
import 'package:trade_trackr/presentation/provider/repository/user_repository/user_repository_provider.dart';

part 'get_user_profile_use_case_provider.g.dart';

@riverpod
GetUserProfileUseCase getUserProfileUseCase(Ref ref) =>
    GetUserProfileUseCase(userRepository: ref.watch(userRepositoryProvider));
