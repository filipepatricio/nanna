import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_cover_state.dt.freezed.dart';

@freezed
class TopicCoverState with _$TopicCoverState {
  @Implements<BuildState>()
  factory TopicCoverState.idle({required bool showPhoto}) = _TopicCoverStateIdle;

  @Implements<BuildState>()
  factory TopicCoverState.loading() = _TopicCoverStateLoading;
}
