import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_page_state.dt.freezed.dart';

@Freezed(toJson: false)
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

  @Implements<BuildState>()
  factory ExplorePageState.searchHistory(List<String> searchHistory) = _ExplorePageStateSearchHistory;

  factory ExplorePageState.searchHistoryUpdated() = _ExplorePageStateSearchHistoryUpdated;

  factory ExplorePageState.searchHistoryQueryTapped(String query) = _ExplorePageStateSearchHistoryQueryTapped;

  factory ExplorePageState.startTyping() = _ExplorePageStateStartTyping;

  factory ExplorePageState.startSearching() = _ExplorePageStateStartSearching;

  factory ExplorePageState.startExploring() = _ExplorePageStateStartExploring;

  factory ExplorePageState.showTutorialToast(String text) = _ExplorePageStateShowTutorialToast;
}
