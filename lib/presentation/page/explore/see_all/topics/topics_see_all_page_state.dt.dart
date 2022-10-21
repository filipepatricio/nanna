import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topics_see_all_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class TopicsSeeAllPageState with _$TopicsSeeAllPageState {
  @Implements<BuildState>()
  factory TopicsSeeAllPageState.loading() = _TopicsSeeAllPageStateLoading;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.withPagination(List<TopicPreview> topics) = _TopicsSeeAllPageStateWithPagination;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.loadingMore(List<TopicPreview> topics) = _TopicsSeeAllPageStateLoadingMore;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.allLoaded(List<TopicPreview> topics) = _TopicsSeeAllPageStateAllLoaded;
}
