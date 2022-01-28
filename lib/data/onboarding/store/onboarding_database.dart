abstract class OnboardingDatabase {
  Future<bool> isOnboardingSeen(String userUuid);

  Future<void> setOnboardingSeen(String userUuid);

  Future<void> resetOnboarding(String userUuid);
}
