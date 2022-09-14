import 'package:purchases_flutter/purchases_flutter.dart';

abstract class PurchasesRepository {
  Future<void> initialize();

  Future<void> identify(String userId);

  Future<bool> hasActiveSubscription();

  Future<Offering> getOffering();

  Future<bool> retorePurchases();

  Future<bool> purchase(Package package);
}
