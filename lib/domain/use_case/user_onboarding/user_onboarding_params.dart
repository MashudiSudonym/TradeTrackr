class UserOnboardingParams {
  final String firstName;
  final String lastName;
  final String? email;

  UserOnboardingParams({
    required this.firstName,
    required this.lastName,
    this.email,
  });
}
