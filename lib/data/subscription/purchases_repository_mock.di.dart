import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchasesRepository, env: mockEnvs)
class PurchasesRepositoryMock implements PurchasesRepository {
  const PurchasesRepositoryMock(this._subscriptionPlanMapper);

  final SubscriptionPlanMapper _subscriptionPlanMapper;

  @override
  Future<bool> hasActiveSubscription() async {
    return true;
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    return _subscriptionPlanMapper(MockDTO.offering);
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
  Future<bool> purchase(SubscriptionPlan plan) async {
    return true;
  }

  @override
  Future<bool> restorePurchase() async {
    return true;
  }
}
