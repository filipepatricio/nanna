import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';

abstract class PurchasesRepository {
  Future<void> initialize();

  Future<void> identify(String userId);

  Future<void> linkWithAppsflyer(String appsflyerId);

  Future<bool> isFirstTimeSubscriber();

  Future<bool> hasActiveSubscription();

  Future<ActiveSubscription> getActiveSubscription();

  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId});

  Future<bool> restorePurchase();

  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId});

  Stream<ActiveSubscription> get activeSubscriptionStream;

  void dispose();
}
