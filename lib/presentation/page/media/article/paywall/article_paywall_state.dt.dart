import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_paywall_state.dt.freezed.dart';

@Freezed(toJson: false)
class ArticlePaywallState with _$ArticlePaywallState {
  @Implements<BuildState>()
  const factory ArticlePaywallState.initializing() = _ArticlePaywallStateInitializing;

  @Implements<BuildState>()
  const factory ArticlePaywallState.loading() = _ArticlePaywallStateLoading;

  @Implements<BuildState>()
  const factory ArticlePaywallState.disabled() = _ArticlePaywallStateDisabled;

  @Implements<BuildState>()
  const factory ArticlePaywallState.trial(SubscriptionPlan plan, bool processing) = _ArticlePaywallStateTrial;

  @Implements<BuildState>()
  const factory ArticlePaywallState.multiplePlans(SubscriptionPlanGroup planGroup, bool processing) =
      _ArticlePaywallStateMultiplePlans;

  const factory ArticlePaywallState.redeemingCode() = _ArticlePaywallStateRedeemingCode;

  const factory ArticlePaywallState.purchaseSuccess() = _ArticlePaywallStatePurchaseSuccess;

  const factory ArticlePaywallState.restoringPurchase() = _ArticlePaywallStateRestoringPurchase;

  const factory ArticlePaywallState.restoringPurchaseError() = _ArticlePaywallStateRestoringPurchaseError;

  const factory ArticlePaywallState.generalError([String? message]) = _ArticlePaywallStateGeneralError;
}
