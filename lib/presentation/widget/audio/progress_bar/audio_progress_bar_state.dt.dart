import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_progress_bar_state.dt.freezed.dart';

@freezed
class AudioProgressBarState with _$AudioProgressBarState {
  @Implements<BuildState>()
  factory AudioProgressBarState.initial() = _AudioProgressBarStateInitial;

  @Implements<BuildState>()
  factory AudioProgressBarState.inactive(double progress) = _AudioProgressBarStateInactive;

  @Implements<BuildState>()
  factory AudioProgressBarState.active(
    Duration progress,
    Duration totalDuration,
  ) = _AudioProgressBarStateActive;
}
