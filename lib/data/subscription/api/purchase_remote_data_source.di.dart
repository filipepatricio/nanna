import 'dart:async';

import 'package:better_informed_mobile/data/subscription/api/exception/purchase_exception_resolver.di.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

typedef PromotedProductPurchaseCallback = Function(String, Future<PromotedPurchaseResult> Function());

@injectable
class PurchaseRemoteDataSource {
  const PurchaseRemoteDataSource(this._purchaseExceptionResolver);

  @factoryMethod
  static Future<PurchaseRemoteDataSource> create(PurchaseExceptionResolver purchaseExceptionResolver) async {
    final dataSource = PurchaseRemoteDataSource(purchaseExceptionResolver);
    await Purchases.setDebugLogsEnabled(kDebugMode);
    return dataSource;
  }

  final PurchaseExceptionResolver _purchaseExceptionResolver;

  Future<void> configure(String apiKey, String? userId) async {
    final configuration = PurchasesConfiguration(apiKey)..appUserID = userId;
    await _purchaseExceptionResolver.callWithResolver(() => Purchases.configure(configuration));
  }

  Future<bool> get isConfigured => Purchases.isConfigured;

  Future<String> get userId => Purchases.appUserID;

  Future<CustomerInfo> getCustomerInfo() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.getCustomerInfo);
  }

  Future<Offerings> getOfferings() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.getOfferings);
  }

  Future<void> logIn(String userId) async {
    return _purchaseExceptionResolver.callWithResolver(() => Purchases.logIn(userId));
  }

  Future<void> logOut() async {
    return _purchaseExceptionResolver.callWithResolver(() => Purchases.logOut());
  }

  Future<CustomerInfo> purchasePackage(Package package, {UpgradeInfo? upgradeInfo}) async {
    return _purchaseExceptionResolver.callWithResolver(
      () => Purchases.purchasePackage(
        package,
        upgradeInfo: upgradeInfo,
      ),
    );
  }

  Future<CustomerInfo> restorePurchases() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.restorePurchases);
  }

  Future<void> collectDeviceIdentifiers() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.collectDeviceIdentifiers);
  }

  Future<void> setAppsflyerID(String appsflyerId) async {
    return _purchaseExceptionResolver.callWithResolver(() => Purchases.setAppsflyerID(appsflyerId));
  }

  Future<void> setFBAnonymousID(String fbAnonymousId) async {
    return _purchaseExceptionResolver.callWithResolver(() => Purchases.setFBAnonymousID(fbAnonymousId));
  }

  Future<void> enableAdServicesAttributionTokenCollection() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.enableAdServicesAttributionTokenCollection);
  }

  Future<void> callWithResolver(FutureOr<dynamic> Function() callback) async {
    return _purchaseExceptionResolver.callWithResolver(callback);
  }

  void addCustomerInfoUpdateListener(Function(CustomerInfo info) callback) {
    Purchases.addCustomerInfoUpdateListener(callback);
  }

  void removeCustomerInfoUpdateListener(Function(CustomerInfo info) callback) {
    Purchases.removeCustomerInfoUpdateListener(callback);
  }

  void addReadyForPromotedProductPurchaseListener(PromotedProductPurchaseCallback callback) {
    Purchases.addReadyForPromotedProductPurchaseListener(callback);
  }

  void removeReadyForPromotedProductPurchaseListener(PromotedProductPurchaseCallback callback) {
    Purchases.removeReadyForPromotedProductPurchaseListener(callback);
  }
}
