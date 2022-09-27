import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';

abstract class PurchasesRepository {
  Future<void> initialize();

  Future<void> identify(String userId);

  Future<bool> isFirstTimeSubscriber();

  Future<bool> hasActiveSubscription();

  Future<ActiveSubscription> getActiveSubscription();

  Future<List<SubscriptionPlan>> getSubscriptionPlans();

  Future<bool> restorePurchase();

  Future<bool> purchase(SubscriptionPlan plan);

  Stream<ActiveSubscription> get activeSubscriptionStream;

  void dispose();
}
