import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_speed_button_state.dt.freezed.dart';

@Freezed(toJson: false)
class AudioSpeedButtonState with _$AudioSpeedButtonState {
  @Implements<BuildState>()
  factory AudioSpeedButtonState.disabled() = _AudioSpeedButtonStateDisabled;

  @Implements<BuildState>()
  factory AudioSpeedButtonState.enabled(double speed) = _AudioSpeedButtonStateEnabled;
}
