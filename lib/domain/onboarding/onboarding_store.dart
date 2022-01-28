abstract class OnboardingStore {
  Future<bool> isUserOnboardingSeen(String userUuid);

  Future<void> setUserOnboardingSeen(String userUuid);

  Future<void> resetUserOnboarding(String userUuid);
}
