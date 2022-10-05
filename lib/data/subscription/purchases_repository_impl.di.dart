import 'dart:async';

import 'package:better_informed_mobile/data/subscription/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/data/subscription/dto/offering_dto.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: PurchasesRepository, env: liveEnvs)
class PurchasesRepositoryImpl implements PurchasesRepository {
  PurchasesRepositoryImpl(
    this._config,
    this._subscriptionPlanMapper,
    this._activeSubscriptionMapper,
  );

  final AppConfig _config;
  final SubscriptionPlanMapper _subscriptionPlanMapper;
  final ActiveSubscriptionMapper _activeSubscriptionMapper;

  var _activeSubscriptionStream = BehaviorSubject<ActiveSubscription>();

  @override
  Future<bool> isFirstTimeSubscriber() async {
    final customer = await Purchases.getCustomerInfo();
    return customer.entitlements.all[_config.revenueCatPremiumEntitlementId] == null;
  }

  @override
  Future<bool> hasActiveSubscription() async {
    final customer = await Purchases.getCustomerInfo();
    return _hasPremiumEntitlement(customer);
  }

  bool _hasPremiumEntitlement(CustomerInfo customer) {
    return customer.entitlements.active[_config.revenueCatPremiumEntitlementId] != null;
  }

  @override
  Future<ActiveSubscription> getActiveSubscription() async {
    final customer = await Purchases.getCustomerInfo();
    final plans = await getSubscriptionPlans();

    return _activeSubscriptionMapper(
      ActiveSubscriptionDTO(
        customer: customer,
        plans: plans,
      ),
    );
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final offerings = await Purchases.getOfferings();
    if (offerings.current != null) {
      return _subscriptionPlanMapper.call(
        OfferingDTO(
          offering: offerings.current!,
          isFirstTimeSubscriber: await isFirstTimeSubscriber(),
        ),
      );
    }

    throw Exception('There is no current offering configured');
  }

  @override
  Future<void> identify(String userId) async {
    if (await Purchases.isConfigured) {
      await Purchases.logIn(userId);
      // Prefetches and caches available offerings
      unawaited(Purchases.getOfferings());

      Purchases.addCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
    }

    return;
  }

  Future<void> _updateActiveSubscriptionStream(CustomerInfo info) async {
    _activeSubscriptionStream.sink.add(await getActiveSubscription());
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
  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId}) async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        throw Exception('There is no current offering configured');
      }

      final package = offerings.current!.availablePackages.firstWhereOrNull(
        (package) => package.identifier == plan.packageId,
      );
      if (package == null) {
        throw Exception('Selected package is not part of the current offering. Id: ${plan.packageId}');
      }

      final customer = await Purchases.purchasePackage(
        package,
        upgradeInfo: oldProductId != null // https://www.revenuecat.com/docs/managing-subscriptions#google-play
            ? UpgradeInfo(oldProductId, prorationMode: ProrationMode.immediateWithTimeProration)
            : null,
      );
      return _hasPremiumEntitlement(customer);
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.productAlreadyPurchasedError) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<bool> restorePurchase() async {
    try {
      final customer = await Purchases.restorePurchases();
      return _hasPremiumEntitlement(customer);
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.missingReceiptFileError) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Stream<ActiveSubscription> get activeSubscriptionStream => _activeSubscriptionStream.stream;

  @override
  void dispose() {
    _activeSubscriptionStream.close();
    _activeSubscriptionStream = BehaviorSubject<ActiveSubscription>();
    Purchases.removeCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
  }
}
