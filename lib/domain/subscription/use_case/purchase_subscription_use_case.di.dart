import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseSubscriptionUseCase {
  PurchaseSubscriptionUseCase(
    this._purchasesRepository,
    this._analyticsRepository,
    this._networkCacheManager,
  );

  final PurchasesRepository _purchasesRepository;
  final AnalyticsRepository _analyticsRepository;
  final NetworkCacheManager _networkCacheManager;

  Future<bool> call(SubscriptionPlan plan, {String? oldProductId}) async {
    final result = await _purchasesRepository.purchase(
      plan,
      oldProductId: oldProductId,
    );
    if (result) {
      _analyticsRepository.event(AnalyticsEvent.subscriptionPlanPurchased(packageId: plan.packageId));
      await _networkCacheManager.clear();
    }
    return result;
  }
}
