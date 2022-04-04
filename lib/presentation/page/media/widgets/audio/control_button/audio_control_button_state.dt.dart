import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_control_button_state.dt.freezed.dart';

@freezed
class AudioControlButtonState with _$AudioControlButtonState {
  @Implements<BuildState>()
  factory AudioControlButtonState.notInitilized() = _AudioControlButtonStateNotInitialized;

  @Implements<BuildState>()
  factory AudioControlButtonState.loading() = _AudioControlButtonStateLoading;

  @Implements<BuildState>()
  factory AudioControlButtonState.playing() = _AudioControlButtonStatePlaying;

  @Implements<BuildState>()
  factory AudioControlButtonState.paused() = _AudioControlButtonStatePaused;
}
