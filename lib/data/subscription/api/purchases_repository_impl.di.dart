import 'dart:async';

import 'package:better_informed_mobile/data/subscription/api/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/data/subscription/api/dto/offering_dto.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/api/purchase_api_data_source.dart';
import 'package:better_informed_mobile/data/subscription/api/purchase_remote_data_source.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/exception/purchase_exception.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:retry/retry.dart';

const currentOfferingKey = 'current';

@Singleton(as: PurchasesRepository, env: liveEnvs)
class PurchasesRepositoryImpl implements PurchasesRepository {
  PurchasesRepositoryImpl(
    this._config,
    this._subscriptionPlanMapper,
    this._activeSubscriptionMapper,
    this._purchaseRemoteDataSource,
    this._analyticsFacade,
    this._purchaseApiDataSource,
  );

  final AppConfig _config;
  final SubscriptionPlanMapper _subscriptionPlanMapper;
  final ActiveSubscriptionMapper _activeSubscriptionMapper;
  final PurchaseRemoteDataSource _purchaseRemoteDataSource;
  final PurchaseApiDataSource _purchaseApiDataSource;
  final AnalyticsFacade _analyticsFacade;

  var _activeSubscriptionStream = StreamController<ActiveSubscription>.broadcast();

  @override
  Stream<ActiveSubscription> get activeSubscriptionStream => _activeSubscriptionStream.stream.distinct();

  @override
  Future<void> initialize(String? userId) async {
    if (await _purchaseRemoteDataSource.isConfigured) {
      if (await _purchaseRemoteDataSource.userId == userId) {
        return;
      }

      if (userId != null) {
        await _purchaseRemoteDataSource.logIn(userId);
        _preCachePurchaseData();
        return;
      }
    }

    try {
      _purchaseRemoteDataSource.addReadyForPromotedProductPurchaseListener(_promotedProductPurchaseListener);

      await retry(
        () async {
          final apiKey = kIsAppleDevice ? _config.revenueCatKeyiOS : _config.revenueCatKeyAndroid;

          if (apiKey != null) {
            await _purchaseRemoteDataSource.configure(apiKey, userId);
          }
        },
        retryIf: _shouldRetry,
      );
    } on PurchaseConfigurationException catch (_) {}

    if (await _purchaseRemoteDataSource.isConfigured) {
      _preCachePurchaseData();
    }
  }

  void _preCachePurchaseData() {
    try {
      // Prefetches and caches available customer info and offerings
      unawaited(_purchaseRemoteDataSource.getCustomerInfo());
      unawaited(_purchaseRemoteDataSource.getOfferings());
      _purchaseRemoteDataSource.addCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
    } on PurchaseConfigurationException catch (_) {}
  }

  @override
  Future<void> login(String userId) async {
    try {
      await _purchaseRemoteDataSource.logIn(userId);
    } on PurchaseConfigurationException catch (_) {}
  }

  @override
  Future<bool> hasActiveSubscription() async {
    final customer = await _purchaseRemoteDataSource.getCustomerInfo();
    return _hasPremiumEntitlement(customer);
  }

  @override
  Future<ActiveSubscription> getActiveSubscription([CustomerInfo? customerInfo]) async {
    final customer = customerInfo ?? await _purchaseRemoteDataSource.getCustomerInfo();
    final plans = await _getAllSubscriptionPlans();

    return _activeSubscriptionMapper(
      ActiveSubscriptionDTO(
        customer: customer,
        plans: plans,
      ),
    );
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId = currentOfferingKey}) async {
    try {
      final offerings = await _purchaseRemoteDataSource.getOfferings();
      final offering = offerings.getCurrentOrCustomOffering(offeringId);
      if (offering != null) {
        return _subscriptionPlanMapper.call(
          OfferingDTO(
            offering: offering,
            isFirstTimeSubscriber: await _isFirstTimeSubscriber(),
          ),
        );
      }

      throw Exception('There is no $offeringId offering configured');
    } on PurchaseConfigurationException {
      return [];
    }
  }

  @override
  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId}) async {
    try {
      final offerings = await _purchaseRemoteDataSource.getOfferings();
      final offering = offerings.getCurrentOrCustomOffering(plan.offeringId);

      final package = offering?.availablePackages.firstWhereOrNull(
        (package) => package.identifier == plan.packageId,
      );
      if (package == null) {
        throw Exception('Selected package is not part of the ${plan.offeringId} offering. Id: ${plan.packageId}');
      }

      final customer = await _purchaseRemoteDataSource.purchasePackage(
        package,
        upgradeInfo: oldProductId != null // https://www.revenuecat.com/docs/managing-subscriptions#google-play
            ? UpgradeInfo(oldProductId, prorationMode: ProrationMode.immediateWithTimeProration)
            : null,
      );
      return _hasPremiumEntitlement(customer);
    } on PurchaseConfigurationException {
      return false;
    } on PurchaseCancelledException {
      return false;
    } on PurchaseAlreadyOwnedException {
      return false;
    }
  }

  @override
  Future<bool> restorePurchase() async {
    try {
      final customer = await _purchaseRemoteDataSource.restorePurchases();
      return _hasPremiumEntitlement(customer);
    } on PurchaseConfigurationException {
      return false;
    } on PurchaseMissingReceiptException {
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    await _activeSubscriptionStream.close();
    _activeSubscriptionStream = StreamController.broadcast();
    _purchaseRemoteDataSource.removeCustomerInfoUpdateListener(_updateActiveSubscriptionStream);
    _purchaseRemoteDataSource.removeReadyForPromotedProductPurchaseListener(_promotedProductPurchaseListener);
    await _purchaseRemoteDataSource.logOut();
  }

  @override
  Future<void> linkWithExternalServices(
    String? appsflyerId,
    String? facebookAnonymousId,
  ) async {
    try {
      await _purchaseRemoteDataSource.collectDeviceIdentifiers();

      if (appsflyerId != null) {
        await _purchaseRemoteDataSource.setAppsflyerID(appsflyerId);
      }

      if (facebookAnonymousId != null) {
        await _purchaseRemoteDataSource.setFBAnonymousID(facebookAnonymousId);
      }
    } on PurchaseConfigurationException catch (_) {}
  }

  @override
  Future<void> precacheSubscriptionPlans() async {
    try {
      await _purchaseRemoteDataSource.getOfferings();
    } on PurchaseConfigurationException catch (_) {}
  }

  @override
  Future<void> collectAppleSearchAdsAttributionData() async {
    await _purchaseRemoteDataSource.enableAdServicesAttributionTokenCollection();
  }

  @override
  Future<bool> forceSubscriptionStatusSync() async {
    final result = await _purchaseApiDataSource.forceSubscriptionStatusSync();
    return result.successful;
  }

  Future<void> _updateActiveSubscriptionStream(CustomerInfo customerInfo) async {
    final currentStream = _activeSubscriptionStream;
    final activeSubscription = await getActiveSubscription(customerInfo);
    if (!currentStream.isClosed) {
      currentStream.sink.add(activeSubscription);
    }
  }

  Future<void> _promotedProductPurchaseListener(
    String productID,
    Future<PromotedPurchaseResult> Function() startPurchase,
  ) async =>
      await _purchaseRemoteDataSource.callWithResolver(
        () async {
          unawaited(_analyticsFacade.event(AnalyticsEvent.promotedProductPurchaseStarted()));
          try {
            final result = await startPurchase();
            await _updateActiveSubscriptionStream(result.customerInfo);
          } on PurchaseCancelledException {
            return;
          }
          return;
        },
      );

  Future<List<SubscriptionPlan>> _getAllSubscriptionPlans() async {
    Offerings offerings;
    try {
      offerings = await _purchaseRemoteDataSource.getOfferings();
    } on PurchaseConfigurationException {
      return [];
    }

    final firstTimeSubscriber = await _isFirstTimeSubscriber();
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

  Future<bool> _isFirstTimeSubscriber() async {
    final customer = await _purchaseRemoteDataSource.getCustomerInfo();
    return customer.entitlements.all[_config.revenueCatPremiumEntitlementId] == null;
  }

  bool _hasPremiumEntitlement(CustomerInfo customer) {
    return customer.entitlements.active[_config.revenueCatPremiumEntitlementId] != null;
  }

  FutureOr<bool> _shouldRetry(exception) {
    return exception is PurchaseUnknownBackendErrorException ||
        exception is PurchaseUnexpectedBackendResponseException ||
        exception is PurchaseUnknownException ||
        exception is PurchaseNetworkException;
  }
}

extension on Offerings {
  Offering? getCurrentOrCustomOffering(String offeringId) {
    if (offeringId == currentOfferingKey) return current;

    return getOffering(offeringId);
  }
}
