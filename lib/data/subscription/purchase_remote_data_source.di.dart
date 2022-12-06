import 'package:better_informed_mobile/data/subscription/exception/purchase_exception_resolver.di.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class PurchaseRemoteDataSource {
  PurchaseRemoteDataSource(this._purchaseExceptionResolver);

  final PurchaseExceptionResolver _purchaseExceptionResolver;

  Future<void> configure(PurchasesConfiguration config) async {
    await Purchases.setDebugLogsEnabled(kDebugMode);

    final configuration = PurchasesConfiguration(config.apiKey);
    await _purchaseExceptionResolver.callWithResolver(() => Purchases.configure(configuration));
  }

  Future<CustomerInfo> getCustomerInfo() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.getCustomerInfo);
  }

  Future<Offerings> getOfferings() async {
    return _purchaseExceptionResolver.callWithResolver(Purchases.getOfferings);
  }

  Future<LogInResult> logIn(String userId) async {
    return _purchaseExceptionResolver.callWithResolver(() => Purchases.logIn(userId));
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

  void addCustomerInfoUpdateListener(Function(CustomerInfo info) callback) {
    Purchases.addCustomerInfoUpdateListener(callback);
  }

  void removeCustomerInfoUpdateListener(Function(CustomerInfo info) callback) {
    Purchases.removeCustomerInfoUpdateListener(callback);
  }
}
