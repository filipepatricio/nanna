import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_page_state.dt.freezed.dart';

@freezed
class ExplorePageState with _$ExplorePageState {
  @Implements<BuildState>()
  factory ExplorePageState.initialLoading() = _ExplorePageStateInitialLoading;

  @Implements<BuildState>()
  factory ExplorePageState.idle(
    List<ExploreItem> items,
    int? backgroundColor,
  ) = _ExplorePageStateIdle;

  @Implements<BuildState>()
  factory ExplorePageState.error() = _ExplorePageStateError;

  factory ExplorePageState.showTutorialToast(String text) = _ExplorePageStateShowTutorialToast;
}
