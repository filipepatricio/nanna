import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_rewind_button_state.freezed.dart';

@freezed
class AudioRewindButtonState with _$AudioRewindButtonState {
  @Implements<BuildState>()
  factory AudioRewindButtonState.disabled() = _AudioRewindButtonStateDisabled;

  @Implements<BuildState>()
  factory AudioRewindButtonState.enabled() = _AudioRewindButtonStateEnabled;
}
