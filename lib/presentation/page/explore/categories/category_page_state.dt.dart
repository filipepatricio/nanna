import 'package:better_informed_mobile/domain/result_item/result_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_page_state.dt.freezed.dart';

@freezed
class CategoryPageState with _$CategoryPageState {
  @Implements<BuildState>()
  factory CategoryPageState.loading() = _CategoryPageStateLoading;

  @Implements<BuildState>()
  factory CategoryPageState.withPagination(List<ResultItem> items) = _CategoryPageStateWithPagination;

  @Implements<BuildState>()
  factory CategoryPageState.loadingMore(List<ResultItem> items) = _CategoryPageStateLoadingMore;

  @Implements<BuildState>()
  factory CategoryPageState.allLoaded(List<ResultItem> items) = _CategoryPageStateAllLoaded;
}
