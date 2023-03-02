import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_brief_badge_switch_state.dt.freezed.dart';

@Freezed(toJson: false)
class DailyBriefBadgeSwitchState with _$DailyBriefBadgeSwitchState {
  @Implements<BuildState>()
  const factory DailyBriefBadgeSwitchState.loading() = _DailyBriefBadgeSwitchStateLoading;

  @Implements<BuildState>()
  const factory DailyBriefBadgeSwitchState.free(bool shouldShowBadge) = _DailyBriefBadgeSwitchStateFree;

  @Implements<BuildState>()
  const factory DailyBriefBadgeSwitchState.premiumOrTrial(bool shouldShowBadge) =
      _DailyBriefBadgeSwitchStatePremiumOrTrial;
}
