import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';

abstract class PurchasesRepository {
  Future<void> initialize();

  Future<void> identify(String userId);

  Future<bool> hasActiveSubscription();

  Future<List<SubscriptionPlan>> getSubscriptionPlans();

  Future<bool> retorePurchase();

  Future<bool> purchase(SubscriptionPlan plan);
}
