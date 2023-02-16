import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubscriptionPlansUseCase {
  GetSubscriptionPlansUseCase(
    this._purchasesRepository,
    this._featuresFlagsRepository,
  );

  final PurchasesRepository _purchasesRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<SubscriptionPlanGroup> call() async {
    final offeringId = await _featuresFlagsRepository.defaultPaywall();
    final plans = await _purchasesRepository.getSubscriptionPlans(offeringId: offeringId);
    return SubscriptionPlanGroup(plans: plans);
  }
}
