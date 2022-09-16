import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@LazySingleton(as: PurchasesRepository, env: mockEnvs)
class PurchasesRepositoryMock implements PurchasesRepository {
  const PurchasesRepositoryMock();

  @override
  Future<bool> hasActiveSubscription() async {
    return false;
  }

  @override
  Future<Offering> getOffering() async {
    return const Offering('premium', 'description', []);
  }

  @override
  Future<void> identify(String userId) async {
    return;
  }

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<bool> purchase(Package package) async {
    return true;
  }

  @override
  Future<bool> retorePurchases() async {
    return true;
  }
}
