import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';

abstract class SubscriptionLocalRepository {
  Future<void> saveActiveSubscription(ActiveSubscription activeSubscription);

  Future<ActiveSubscription?> loadActiveSubscription();

  Future<void> clear(String userUuid);
}
