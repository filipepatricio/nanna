import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_owner_page_state.freezed.dart';

@freezed
class TopicOwnerPageState with _$TopicOwnerPageState {
  @Implements<BuildState>()
  factory TopicOwnerPageState.idleExpert(List<Topic> topicsFromExpert) = _TopicOwnerPageStateIdleExpert;

  @Implements<BuildState>()
  factory TopicOwnerPageState.idleEditor() = _TopicOwnerPageStateIdleEditor;

  @Implements<BuildState>()
  factory TopicOwnerPageState.loading() = _TopicOwnerPageStateLoading;

  @Implements<BuildState>()
  factory TopicOwnerPageState.error() = _TopicOwnerPageStateError;

  factory TopicOwnerPageState.browserError(String link) = _TopicOwnerPageStateBrowserError;
}
