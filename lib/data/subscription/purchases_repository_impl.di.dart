import 'dart:async';

import 'package:better_informed_mobile/data/subscription/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/data/subscription/dto/offering_dto.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const _currentOfferingKey = 'current';

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

  var _activeSubscriptionStream = StreamController<ActiveSubscription>.broadcast();

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
    final plans = await _getAllSubscriptionPlans();

    return _activeSubscriptionMapper(
      ActiveSubscriptionDTO(
        customer: customer,
        plans: plans,
      ),
    );
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId = _currentOfferingKey}) async {
    final offerings = await Purchases.getOfferings();
    final offering = offerings.getCurrentOrCustomOffering(offeringId);
    if (offering != null) {
      return _subscriptionPlanMapper.call(
        OfferingDTO(
          offering: offering,
          isFirstTimeSubscriber: await isFirstTimeSubscriber(),
        ),
      );
    }

    throw Exception('There is no $offeringId offering configured');
  }

  @override
  Future<void> identify(String userId) async {
    if (await Purchases.isConfigured) {
      await Purchases.logIn(userId);
      // Prefetches and caches available offerings
      unawaited(Purchases.getOfferings());

      Purchases.addCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
    }
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
      final offering = offerings.getCurrentOrCustomOffering(plan.offeringId);

      final package = offering?.availablePackages.firstWhereOrNull(
        (package) => package.identifier == plan.packageId,
      );
      if (package == null) {
        throw Exception('Selected package is not part of the ${plan.offeringId} offering. Id: ${plan.packageId}');
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
  Stream<ActiveSubscription> get activeSubscriptionStream => _activeSubscriptionStream.stream.distinct();

  @override
  void dispose() {
    _activeSubscriptionStream.close();
    _activeSubscriptionStream = StreamController.broadcast();
    Purchases.removeCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
  }

  Future<List<SubscriptionPlan>> _getAllSubscriptionPlans() async {
    final offerings = await Purchases.getOfferings();
    final firstTimeSubscriber = await isFirstTimeSubscriber();
    if (offerings.all.values.isEmpty) return [];

    return offerings.all.values
        .map(
          (offering) => _subscriptionPlanMapper.call(
            OfferingDTO(
              offering: offering,
              isFirstTimeSubscriber: firstTimeSubscriber,
            ),
          ),
        )
        .flattened
        .toList();
  }
}

extension on Offerings {
  Offering? getCurrentOrCustomOffering(String offeringId) {
    if (offeringId == _currentOfferingKey) return current;

    return getOffering(offeringId);
  }
}
