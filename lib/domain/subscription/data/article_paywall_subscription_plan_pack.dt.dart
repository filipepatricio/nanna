import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_paywall_subscription_plan_pack.dt.freezed.dart';

@Freezed(toJson: false)
class ArticlePaywallSubscriptionPlanPack with _$ArticlePaywallSubscriptionPlanPack {
  factory ArticlePaywallSubscriptionPlanPack.singleTrial(SubscriptionPlan plan) =
      _ArticlePaywallSubscriptionPlanPackSingleTrial;

  factory ArticlePaywallSubscriptionPlanPack.multiple(List<SubscriptionPlan> plans) =
      _ArticlePaywallSubscriptionPlanPackMultiple;
}
