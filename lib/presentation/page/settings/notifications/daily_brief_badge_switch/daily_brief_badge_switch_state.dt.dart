import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_brief_badge_switch_state.dt.freezed.dart';

@Freezed(toJson: false)
class DailyBriefBadgeSwitchState with _$DailyBriefBadgeSwitchState {
  @Implements<BuildState>()
  factory DailyBriefBadgeSwitchState.notInitialized() = _DailyBriefBadgeSwitchStateNotInitialized;

  @Implements<BuildState>()
  factory DailyBriefBadgeSwitchState.idle(bool isShowingBadge) = _DailyBriefBadgeSwitchStateIdle;
}
