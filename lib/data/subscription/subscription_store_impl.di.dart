import 'package:better_informed_mobile/data/subscription/store/subscription_database.dart';
import 'package:better_informed_mobile/domain/subscription/store/subscription_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SubscriptionStore)
class SubscriptionStoreImpl extends SubscriptionStore {
  SubscriptionStoreImpl(this._subscriptionDatabase);
  final SubscriptionDatabase _subscriptionDatabase;

  @override
  Future<bool> isOnboardingPaywallSeen(String userUuid) async =>
      await _subscriptionDatabase.isOnboardingPaywallSeen(userUuid);

  @override
  Future<void> resetSubscriptionStore(String userUuid) async =>
      await _subscriptionDatabase.resetUserSubscriptionStore(userUuid);

  @override
  Future<void> setOnboardingPaywallSeen(String userUuid) async =>
      await _subscriptionDatabase.setOnboardingPaywallSeen(userUuid);
}
