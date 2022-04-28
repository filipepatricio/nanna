abstract class OnboardingDatabase {
  @Deprecated('Deprecated after version 1.6, to be removed')
  Future<bool> isOnboardingSeen(String userUuid);

  Future<int?> getOnboardingVersion(String userUuid);

  Future<void> setOnboardingVersion(String userUuid, int version);

  Future<void> resetOnboarding(String userUuid);
}
