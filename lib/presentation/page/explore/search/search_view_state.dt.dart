import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_view_state.dt.freezed.dart';

@freezed
class SearchViewState with _$SearchViewState {
  @Implements<BuildState>()
  factory SearchViewState.initial() = _SearchViewStateInitial;

  @Implements<BuildState>()
  factory SearchViewState.loading() = _SearchViewStateLoading;

  @Implements<BuildState>()
  factory SearchViewState.empty(String query) = _SearchViewStateEmpty;

  @Implements<BuildState>()
  factory SearchViewState.idle(List<SearchResult> results) = _SearchViewStateIdle;

  @Implements<BuildState>()
  factory SearchViewState.loadMore(List<SearchResult> results) = _SearchViewStateLoadMore;

  @Implements<BuildState>()
  factory SearchViewState.allLoaded(List<SearchResult> results) = _SearchViewStateAllLoaded;

  factory SearchViewState.queryChanged() = _SearchViewStateQueryChanged;
}
