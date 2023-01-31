import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_tab_bar_badge_state.dt.freezed.dart';

@Freezed(toJson: false)
class TodayTabBarBadgeState with _$TodayTabBarBadgeState {
  @Implements<BuildState>()
  factory TodayTabBarBadgeState.initializing() = _TodayTabBarBadgeStateInitializing;

  @Implements<BuildState>()
  factory TodayTabBarBadgeState.idle(
    int unseenCount,
  ) = _TodayTabBarBadgeStateIdle;
}
