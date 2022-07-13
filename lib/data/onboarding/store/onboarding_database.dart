abstract class OnboardingDatabase {
  Future<int?> getOnboardingVersion(String userUuid);

  Future<void> setOnboardingVersion(String userUuid, int version);

  Future<void> resetOnboarding(String userUuid);
}
