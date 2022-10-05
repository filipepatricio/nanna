import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
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

  Future<List<SubscriptionPlan>> call() async {
    final offeringId = await _featuresFlagsRepository.defaultPaywall();
    return await _purchasesRepository.getSubscriptionPlans(offeringId: offeringId);
  }
}
