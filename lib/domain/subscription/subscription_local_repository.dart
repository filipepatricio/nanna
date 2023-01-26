import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';

abstract class SubscriptionLocalRepository {
  Future<bool> isOnboardingPaywallSeen(String userUuid);

  Future<void> setOnboardingPaywallSeen(String userUuid);

  Future<void> saveActiveSubscription(ActiveSubscription activeSubscription);

  Future<ActiveSubscription?> loadActiveSubscription();

  Future<void> clear(String userUuid);
}
