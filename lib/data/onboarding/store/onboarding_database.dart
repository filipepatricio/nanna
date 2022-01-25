abstract class OnboardingDatabase {
  Future<bool> isOnboardingSeen();

  Future<void> setOnboardingSeen();

  Future<void> resetOnboarding();
}
