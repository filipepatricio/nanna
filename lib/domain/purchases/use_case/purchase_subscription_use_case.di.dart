import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseSubscriptionUseCase {
  PurchaseSubscriptionUseCase(
    this._purchasesRepository,
    this._analyticsRepository,
  );

  final PurchasesRepository _purchasesRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<bool> call(SubscriptionPlan plan) async {
    final result = await _purchasesRepository.purchase(plan);
    if (result) _analyticsRepository.event(AnalyticsEvent.subscriptionPlanPurchased(packageId: plan.packageId));
    return result;
  }
}
