import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_bar_state.dt.freezed.dart';

@Freezed(toJson: false)
class TabBarState with _$TabBarState {
  @Implements<BuildState>()
  const factory TabBarState.idle() = _TabBarStateIdle;

  const factory TabBarState.tabPressed(MainTab tab) = _TabBarStateTabPressed;

  const factory TabBarState.scrollToTop() = _TabBarStateScrollToTop;
}
