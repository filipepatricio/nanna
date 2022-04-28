abstract class OnboardingDatabase {
  // TODO: We should remove this one when all users will migrate
  Future<bool> isOnboardingSeen(String userUuid);

  Future<int?> getOnboardingVersion(String userUuid);

  Future<void> setOnboardingVersion(String userUuid, int version);

  Future<void> resetOnboarding(String userUuid);
}
