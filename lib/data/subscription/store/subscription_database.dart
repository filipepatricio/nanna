abstract class SubscriptionDatabase {
  Future<bool> isOnboardingPaywallSeen(String userUuid);

  Future<void> setOnboardingPaywallSeen(String userUuid);

  Future<void> resetUserSubscriptionStore(String userUuid);
}
