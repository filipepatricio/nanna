import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_plan_group.dt.freezed.dart';

@Freezed(toJson: false)
class SubscriptionPlanGroup with _$SubscriptionPlanGroup {
  const factory SubscriptionPlanGroup({
    required List<SubscriptionPlan> plans,
  }) = _SubscriptionPlanGroup;

  const SubscriptionPlanGroup._();

  SubscriptionPlan get highestMonthlyCostPlan {
    return plans.reduce((value, element) => value.monthlyPrice > element.monthlyPrice ? value : element);
  }

  bool get hasTrial => plans.every((element) => element.hasTrial);
}
