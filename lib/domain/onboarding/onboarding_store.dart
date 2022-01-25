abstract class OnboardingStore {
  Future<bool> isOnboardingSeen();

  Future<void> setOnboardingSeen();

  Future<void> resetOnboarding();
}
