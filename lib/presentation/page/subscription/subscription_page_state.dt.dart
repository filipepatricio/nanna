import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_page_state.dt.freezed.dart';

@freezed
class SubscriptionPageState with _$SubscriptionPageState {
  @Implements<BuildState>()
  factory SubscriptionPageState.initializing() = _SubscriptionPageStateInitial;

  @Implements<BuildState>()
  factory SubscriptionPageState.idle() = _SubscriptionPageStateIdle;

  @Implements<BuildState>()
  factory SubscriptionPageState.processing() = _SubscriptionPageStateProcessing;

  @Implements<BuildState>()
  factory SubscriptionPageState.success() = _SubscriptionPageStateSuccess;

  factory SubscriptionPageState.generalError() = _SubscriptionPageStateGeneralError;
}
