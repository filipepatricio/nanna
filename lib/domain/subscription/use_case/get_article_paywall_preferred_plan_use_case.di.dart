import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticlePaywallPreferredPlanUseCase {
  GetArticlePaywallPreferredPlanUseCase(
    this._purchasesRepository,
    this._getPreferredSubscriptionPlanUseCase,
  );

  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final PurchasesRepository _purchasesRepository;

  Future<ArticlePaywallSubscriptionPlanPack> call() async {
    final allPlans = await _purchasesRepository.getSubscriptionPlans();
    final trialPlans = allPlans.where((element) => element.hasTrial);

    if (trialPlans.isEmpty) return ArticlePaywallSubscriptionPlanPack.multiple(allPlans);

    final prefferedTrialPlan = _getPreferredSubscriptionPlanUseCase(trialPlans.toList());
    return ArticlePaywallSubscriptionPlanPack.singleTrial(prefferedTrialPlan);
  }
}