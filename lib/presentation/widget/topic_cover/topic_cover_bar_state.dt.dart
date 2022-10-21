import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_cover_bar_state.dt.freezed.dart';

@Freezed(toJson: false)
class TopicCoverBarState with _$TopicCoverBarState {
  @Implements<BuildState>()
  factory TopicCoverBarState.idle() = _TopicCoverBarStateIdle;

  @Implements<BuildState>()
  factory TopicCoverBarState.loading() = _TopicCoverBarStateLoading;

  @Implements<BuildState>()
  factory TopicCoverBarState.share({required Topic topic, required ShareOptions? options}) = _TopicCoverBarStateShare;
}
