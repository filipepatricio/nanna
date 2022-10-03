import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_card_state.dt.freezed.dart';

@freezed
class SubscriptionCardState with _$SubscriptionCardState {
  @Implements<BuildState>()
  const factory SubscriptionCardState.loading() = _SubscriptionCardStateLoading;

  @Implements<BuildState>()
  const factory SubscriptionCardState.free() = _SubscriptionCardStateFree;

  @Implements<BuildState>()
  const factory SubscriptionCardState.trial({required int remainingDays}) = _SubscriptionCardStateTrial;

  @Implements<BuildState>()
  const factory SubscriptionCardState.premium() = _SubscriptionCardStatePremium;
}
