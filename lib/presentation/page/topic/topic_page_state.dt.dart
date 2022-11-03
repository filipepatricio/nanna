import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class TopicPageState with _$TopicPageState {
  @Implements<BuildState>()
  factory TopicPageState.idle(Topic topic) = _TopicPageStateStateIdle;

  @Implements<BuildState>()
  factory TopicPageState.loading() = _TopicPageStateLoading;

  @Implements<BuildState>()
  factory TopicPageState.error() = _TopicPageStateError;

  factory TopicPageState.showTutorialToast(String text) = _TopicPageStateShowTutorialToast;
}
