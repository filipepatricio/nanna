import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_seek_button_state.dt.freezed.dart';

@freezed
class AudioSeekButtonState with _$AudioSeekButtonState {
  @Implements<BuildState>()
  factory AudioSeekButtonState.disabled() = _AudioSeekButtonStateDisabled;

  @Implements<BuildState>()
  factory AudioSeekButtonState.enabled() = _AudioSeekButtonStateEnabled;
}
