import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_subscription_page_state.dt.freezed.dart';

@freezed
class ChangeSubscriptionPageState with _$ChangeSubscriptionPageState {
  @Implements<BuildState>()
  const factory ChangeSubscriptionPageState.initializing() = _ChangeSubscriptionPageStateInit;

  @Implements<BuildState>()
  const factory ChangeSubscriptionPageState.idle({
    required List<SubscriptionPlan> plans,
    required ActiveSubscription subscription,
  }) = _ChangeSubscriptionPageStateIdle;

  @Implements<BuildState>()
  const factory ChangeSubscriptionPageState.processing({
    required List<SubscriptionPlan> plans,
    required ActiveSubscription subscription,
  }) = _ChangeSubscriptionPageStateProcessing;

  factory ChangeSubscriptionPageState.success() = _ChangeSubscriptionPageStateSuccess;

  factory ChangeSubscriptionPageState.generalError() = _ChangeSubscriptionPageStateGeneralError;
}
