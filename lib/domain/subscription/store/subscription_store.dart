abstract class SubscriptionStore {
  Future<bool> isOnboardingPaywallSeen(String userUuid);

  Future<void> setOnboardingPaywallSeen(String userUuid);

  Future<void> resetSubscriptionStore(String userUuid);
}
