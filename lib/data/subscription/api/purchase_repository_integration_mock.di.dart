import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchasesRepository, env: integrationTestEnvs)
class PurchaseRepositoryIntegrationMock implements PurchasesRepository {
  @override
  Stream<ActiveSubscription> get activeSubscriptionStream => throw UnimplementedError();

  @override
  Future<void> collectAppleSearchAdsAttributionData() {
    return Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  void dispose() {}

  @override
  Future<ActiveSubscription> getActiveSubscription() async {
    return ActiveSubscription.manualPremium('www.informed.so', null);
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId = 'current'}) async {
    return [
      SubscriptionPlan(
        type: SubscriptionPlanType.monthly,
        title: 'Monthly',
        description: 'Monthly plan',
        price: 9.99,
        priceString: '9.99',
        monthlyPrice: 9.99,
        monthlyPriceString: '9.99',
        trialDays: 0,
        reminderDays: 14,
        offeringId: offeringId,
        packageId: 'packageId',
        productId: 'productId',
      ),
    ];
  }

  @override
  Future<bool> hasActiveSubscription() async {
    return true;
  }

  @override
  Future<void> initialize(String userId) {
    return Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> linkWithExternalServices(String? appsflyerId, String? facebookAnonymousId) async {}

  @override
  Future<void> precacheSubscriptionPlans() async {}

  @override
  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId}) async {
    return false;
  }

  @override
  Future<bool> restorePurchase() async {
    return false;
  }

  @override
  Future<void> redeemOfferCode() async {}
}
