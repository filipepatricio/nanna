import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPreferredSubscriptionPlanUseCase {
  GetPreferredSubscriptionPlanUseCase();

  SubscriptionPlan call(List<SubscriptionPlan> plans) => plans.firstWhere(
        (plan) => plan.isAnnual,
        orElse: () => plans.first,
      );
}
