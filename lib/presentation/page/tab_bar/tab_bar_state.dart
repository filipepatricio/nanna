import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_bar_state.freezed.dart';

@freezed
class TabBarState with _$TabBarState {
  @Implements<BuildState>()
  const factory TabBarState.init() = _TabBarStateInit;

  const factory TabBarState.tabPressed(MainTab tab) = _TabBarStateTabPressed;
}
