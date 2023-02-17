import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class SubscriptionPageState with _$SubscriptionPageState {
  @Implements<BuildState>()
  const factory SubscriptionPageState.initializing() = _SubscriptionPageStateInitial;

  @Implements<BuildState>()
  const factory SubscriptionPageState.idle({
    required SubscriptionPlanGroup group,
    required SubscriptionPlan selectedPlan,
  }) = _SubscriptionPageStateIdle;

  @Implements<BuildState>()
  const factory SubscriptionPageState.processing({
    required SubscriptionPlanGroup group,
    required SubscriptionPlan selectedPlan,
  }) = _SubscriptionPageStateProcessing;

  @Implements<BuildState>()
  const factory SubscriptionPageState.success({required bool withTrial}) = _SubscriptionPageStateSuccess;

  const factory SubscriptionPageState.restoringPurchase() = _SubscriptionPageStateRestoringPurchase;

  const factory SubscriptionPageState.restoringPurchaseError() = _SubscriptionPageStateRestoringPurchaseError;

  const factory SubscriptionPageState.generalError([String? message]) = _SubscriptionPageStateGeneralError;
}
