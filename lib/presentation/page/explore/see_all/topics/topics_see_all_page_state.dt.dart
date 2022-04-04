import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topics_see_all_page_state.dt.freezed.dart';

@freezed
class TopicsSeeAllPageState with _$TopicsSeeAllPageState {
  @Implements<BuildState>()
  factory TopicsSeeAllPageState.loading() = _TopicsSeeAllPageStateLoading;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.withPagination(List<Topic> topics) = _TopicsSeeAllPageStateWithPagination;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.loadingMore(List<Topic> topics) = _TopicsSeeAllPageStateLoadingMore;

  @Implements<BuildState>()
  factory TopicsSeeAllPageState.allLoaded(List<Topic> topics) = _TopicsSeeAllPageStateAllLoaded;
}
