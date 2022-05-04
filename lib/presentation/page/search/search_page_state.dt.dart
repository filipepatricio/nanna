import 'package:better_informed_mobile/domain/search/data/search_content.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_page_state.dt.freezed.dart';

@freezed
class SearchPageState with _$SearchPageState {
  @Implements<BuildState>()
  factory SearchPageState.loading() = _SearchPageStateInitialLoading;

  @Implements<BuildState>()
  factory SearchPageState.idle(SearchContent searchContent) = _SearchPageStateIdle;

  @Implements<BuildState>()
  factory SearchPageState.error() = _SearchPageStateError;
}
