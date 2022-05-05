import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_page_state.dt.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  @Implements<BuildState>()
  factory SearchPageState.initial() = _SearchPageStateInitial;

  @Implements<BuildState>()
  factory SearchPageState.loading() = _SearchPageStateLoading;

  @Implements<BuildState>()
  factory SearchPageState.empty() = _SearchPageStateEmpty;

  @Implements<BuildState>()
  factory SearchPageState.idle(List<SearchResult> results) = _SearchPageStateIdle;

  @Implements<BuildState>()
  factory SearchPageState.loadMore(List<SearchResult> results) = _SearchPageStateLoadMore;

  @Implements<BuildState>()
  factory SearchPageState.allLoaded(List<SearchResult> results) = _SearchPageStateAllLoaded;
}
