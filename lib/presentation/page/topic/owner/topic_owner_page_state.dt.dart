import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_owner_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class TopicOwnerPageState with _$TopicOwnerPageState {
  @Implements<BuildState>()
  factory TopicOwnerPageState.idleExpert(List<TopicPreview> topics) = _TopicOwnerPageStateIdleExpert;

  @Implements<BuildState>()
  factory TopicOwnerPageState.idleEditor(List<TopicPreview> topics) = _TopicOwnerPageStateIdleEditor;

  @Implements<BuildState>()
  factory TopicOwnerPageState.idleEditorialTeam() = _TopicOwnerPageStateIdleEditorialTeam;

  @Implements<BuildState>()
  factory TopicOwnerPageState.loading() = _TopicOwnerPageStateLoading;

  @Implements<BuildState>()
  factory TopicOwnerPageState.error() = _TopicOwnerPageStateError;

  factory TopicOwnerPageState.browserError(String link) = _TopicOwnerPageStateBrowserError;
}
