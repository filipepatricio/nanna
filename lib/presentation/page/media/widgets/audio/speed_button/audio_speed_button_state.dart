import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_speed_button_state.freezed.dart';

@freezed
class AudioSpeedButtonState with _$AudioSpeedButtonState {
  @Implements<BuildState>()
  factory AudioSpeedButtonState.notInitialized() = _AudioSpeedButtonStateNotInitialized;

  @Implements<BuildState>()
  factory AudioSpeedButtonState.idle(double speed) = _AudioSpeedButtonStateIdle;
}
