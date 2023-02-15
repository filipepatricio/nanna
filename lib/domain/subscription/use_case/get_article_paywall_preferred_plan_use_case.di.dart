import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticlePaywallPreferredPlanUseCase {
  GetArticlePaywallPreferredPlanUseCase(
    this._purchasesRepository,
    this._getPreferredSubscriptionPlanUseCase,
    this._featuresFlagsRepository,
  );

  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final PurchasesRepository _purchasesRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<ArticlePaywallSubscriptionPlanPack> call() async {
    final offeringId = await _featuresFlagsRepository.defaultPaywall();
    final allPlans = await _purchasesRepository.getSubscriptionPlans(offeringId: offeringId);
    final trialPlans = allPlans.where((element) => element.hasTrial);

    if (trialPlans.isEmpty) return ArticlePaywallSubscriptionPlanPack.multiple(SubscriptionPlanGroup(plans: allPlans));

    final prefferedTrialPlan = _getPreferredSubscriptionPlanUseCase(trialPlans.toList());
    return ArticlePaywallSubscriptionPlanPack.singleTrial(prefferedTrialPlan);
  }
}
