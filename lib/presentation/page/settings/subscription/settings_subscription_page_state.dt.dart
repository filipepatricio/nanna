import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_subscription_page_state.dt.freezed.dart';

@freezed
class SettingsSubscriptionPageState with _$SettingsSubscriptionPageState {
  @Implements<BuildState>()
  const factory SettingsSubscriptionPageState.init() = _SettingsSubscriptionPageStateInit;

  @Implements<BuildState>()
  const factory SettingsSubscriptionPageState.loading() = _SettingsSubscriptionPageStateLoading;

  @Implements<BuildState>()
  const factory SettingsSubscriptionPageState.trial({required ActiveSubscriptionTrial subscription}) =
      _SettingsSubscriptionPageStateTrial;

  @Implements<BuildState>()
  const factory SettingsSubscriptionPageState.premium({required ActiveSubscriptionPremium subscription}) =
      _SettingsSubscriptionPageStatePremium;
}
