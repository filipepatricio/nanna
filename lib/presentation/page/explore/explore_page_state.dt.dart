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
  ) = _ExplorePageStateIdle;

  @Implements<BuildState>()
  factory ExplorePageState.error() = _ExplorePageStateError;

  @Implements<BuildState>()
  factory ExplorePageState.search() = _ExplorePageStateSearch;

  factory ExplorePageState.startTyping() = _ExplorePageStateStartTyping;

  factory ExplorePageState.startSearching() = _ExplorePageStateStartSearching;

  factory ExplorePageState.startExploring() = _ExplorePageStateStartExploring;

  factory ExplorePageState.showTutorialToast(String text) = _ExplorePageStateShowTutorialToast;
}
