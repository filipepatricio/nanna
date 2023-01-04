import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_paywall_state.dt.freezed.dart';

@Freezed(toJson: false)
class ArticlePaywallState with _$ArticlePaywallState {
  @Implements<BuildState>()
  factory ArticlePaywallState.initializing() = _ArticlePaywallStateInitializing;

  @Implements<BuildState>()
  factory ArticlePaywallState.loading() = _ArticlePaywallStateLoading;

  @Implements<BuildState>()
  factory ArticlePaywallState.disabled() = _ArticlePaywallStateDisabled;

  @Implements<BuildState>()
  factory ArticlePaywallState.trial(SubscriptionPlan plan, bool processing) = _ArticlePaywallStateTrial;

  @Implements<BuildState>()
  factory ArticlePaywallState.multiplePlans(List<SubscriptionPlan> plans, bool processing) =
      _ArticlePaywallStateMultiplePlans;

  factory ArticlePaywallState.purchaseSuccess() = _ArticlePaywallStatePurchaseSuccess;

  factory ArticlePaywallState.restoringPurchase() = _ArticlePaywallStateRestoringPurchase;

  factory ArticlePaywallState.generalError() = _ArticlePaywallStateGeneralError;
}
