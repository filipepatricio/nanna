import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/purchases/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@LazySingleton(as: PurchasesRepository, env: liveEnvs)
class PurchasesRepositoryImpl implements PurchasesRepository {
  const PurchasesRepositoryImpl(
    this._config,
    this._subscriptionPlanMapper,
  );

  final AppConfig _config;
  final SubscriptionPlanMapper _subscriptionPlanMapper;
  @override
  Future<bool> hasActiveSubscription() async {
    final customer = await Purchases.getCustomerInfo();
    return customer.entitlements.active[_config.revenueCatPremiumEntitlementId] != null;
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final offerings = await Purchases.getOfferings();
    if (offerings.current != null) {
      return _subscriptionPlanMapper.call(offerings.current!);
    }
    throw Exception('There is no current offering configured');
  }

  @override
  Future<void> identify(String userId) async {
    await Purchases.logIn(userId);
    return;
  }

  @override
  Future<void> initialize() async {
    await Purchases.setDebugLogsEnabled(kDebugMode);

    final apiKey = kIsAppleDevice ? _config.revenueCatKeyiOS : _config.revenueCatKeyAndroid;

    if (apiKey != null) {
      final configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
    }
  }

  @override
  Future<bool> purchase(SubscriptionPlan plan) async {
    try {
      final updatedCustomer = await Purchases.purchasePackage(plan.package);
      return updatedCustomer.entitlements.active[_config.revenueCatPremiumEntitlementId] != null;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<bool> retorePurchase() async {
    try {
      final updatedCustomer = await Purchases.restorePurchases();
      return updatedCustomer.entitlements.active[_config.revenueCatPremiumEntitlementId] != null;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.missingReceiptFileError) {
        return false;
      }
      rethrow;
    }
  }
}
