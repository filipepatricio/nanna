import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_note_video_controls_state.dt.freezed.dart';

@Freezed(toJson: false)
class ReleaseNoteVideoControlsState with _$ReleaseNoteVideoControlsState {
  @Implements<BuildState>()
  factory ReleaseNoteVideoControlsState.empty(bool playing) = _ReleaseNoteVideoControlsStateEmpty;

  @Implements<BuildState>()
  factory ReleaseNoteVideoControlsState.overlay(bool playing) = _ReleaseNoteVideoControlsStateOverlay;
}
