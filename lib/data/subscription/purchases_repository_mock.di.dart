import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchasesRepository, env: mockEnvs)
class PurchasesRepositoryMock implements PurchasesRepository {
  const PurchasesRepositoryMock(
    this._subscriptionPlanMapper,
    this._activeSubscriptionMapper,
  );

  final SubscriptionPlanMapper _subscriptionPlanMapper;
  final ActiveSubscriptionMapper _activeSubscriptionMapper;

  @override
  Future<bool> hasActiveSubscription() async {
    return true;
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans({String offeringId = 'current'}) async {
    return _subscriptionPlanMapper(MockDTO.offeringWithTrial);
  }

  @override
  Future<void> initialize(String userId) async {
    return;
  }

  @override
  Future<bool> purchase(SubscriptionPlan plan, {String? oldProductId}) async {
    return true;
  }

  @override
  Future<bool> restorePurchase() async {
    return true;
  }

  @override
  Future<ActiveSubscription> getActiveSubscription() async {
    return _activeSubscriptionMapper(MockDTO.activeSubscription);
  }

  @override
  Stream<ActiveSubscription> get activeSubscriptionStream async* {
    yield _activeSubscriptionMapper(MockDTO.activeSubscription);
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<void> linkWithExternalServices(String? appsflyerId, String? facebookAnonymousId) async {}

  @override
  Future<void> precacheSubscriptionPlans() async {
    return;
  }

  @override
  Future<void> collectAppleSearchAdsAttributionData() async {
    return;
  }
}
