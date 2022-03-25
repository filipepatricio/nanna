import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_control_button_state.freezed.dart';

@freezed
class AudioControlButtonState with _$AudioControlButtonState {
  @Implements<BuildState>()
  factory AudioControlButtonState.initializing() = _AudioControlButtonStateInitializing;

  @Implements<BuildState>()
  factory AudioControlButtonState.playing() = _AudioControlButtonStatePlaying;

  @Implements<BuildState>()
  factory AudioControlButtonState.paused() = _AudioControlButtonStatePaused;
}
