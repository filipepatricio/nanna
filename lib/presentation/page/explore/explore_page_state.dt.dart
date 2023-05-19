import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class ExplorePageState with _$ExplorePageState {
  @Implements<BuildState>()
  const factory ExplorePageState.initialLoading() = _ExplorePageStateInitialLoading;

  @Implements<BuildState>()
  const factory ExplorePageState.idle(List<ExploreItem> items) = _ExplorePageStateIdle;

  @Implements<BuildState>()
  const factory ExplorePageState.idleGuest(List<ExploreItem> items) = _ExplorePageStateIdleGuest;

  @Implements<BuildState>()
  const factory ExplorePageState.error() = _ExplorePageStateError;

  @Implements<BuildState>()
  const factory ExplorePageState.offline() = _ExplorePageStateOffline;

  @Implements<BuildState>()
  const factory ExplorePageState.search() = _ExplorePageStateSearch;

  @Implements<BuildState>()
  const factory ExplorePageState.searchHistory(List<String> searchHistory) = _ExplorePageStateSearchHistory;

  const factory ExplorePageState.searchHistoryUpdated() = _ExplorePageStateSearchHistoryUpdated;

  const factory ExplorePageState.searchHistoryQueryTapped(String query) = _ExplorePageStateSearchHistoryQueryTapped;

  const factory ExplorePageState.startTyping() = _ExplorePageStateStartTyping;

  const factory ExplorePageState.startSearching() = _ExplorePageStateStartSearching;

  const factory ExplorePageState.startExploring() = _ExplorePageStateStartExploring;

  const factory ExplorePageState.showTutorialToast() = _ExplorePageStateShowTutorialToast;
}
