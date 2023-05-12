import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';

abstract class PurchasesRepository {
  Future<void> initialize(String? userId);

  Future<void> login(String userId);

  Future<void> linkWithExternalServices(
    String? appsflyerId,
    String? facebookAnonymousId,
  );

  Future<bool> hasActiveSubscription();

  Future<ActiveSubscription> getActiveSubscription();

  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId});

  Future<bool> restorePurchase();

  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId});

  Stream<ActiveSubscription> get activeSubscriptionStream;

  Future<void> precacheSubscriptionPlans();

  Future<void> collectAppleSearchAdsAttributionData();

  Future<bool> forceSubscriptionStatusSync();

  Future<void> dispose();
}
