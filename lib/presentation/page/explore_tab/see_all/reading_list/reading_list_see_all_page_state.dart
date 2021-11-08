import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_list_see_all_page_state.freezed.dart';

@freezed
class ReadingListSeeAllPageState with _$ReadingListSeeAllPageState {
  @Implements(BuildState)
  factory ReadingListSeeAllPageState.loading() = _ReadingListSeeAllPageStateLoading;

  @Implements(BuildState)
  factory ReadingListSeeAllPageState.withPagination(List<Topic> topics) = _ReadingListSeeAllPageStateWithPagination;

  @Implements(BuildState)
  factory ReadingListSeeAllPageState.loadingMore(List<Topic> topics) = _ReadingListSeeAllPageStateLoadingMore;

  @Implements(BuildState)
  factory ReadingListSeeAllPageState.allLoaded(List<Topic> topics) = _ReadingListSeeAllPageStateAllLoaded;
}
