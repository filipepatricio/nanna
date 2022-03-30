import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_fast_forward_button_state.freezed.dart';

@freezed
class AudioFastForwardButtonState with _$AudioFastForwardButtonState {
  @Implements<BuildState>()
  factory AudioFastForwardButtonState.disabled() = _AudioFastForwardButtonStateDisabled;

  @Implements<BuildState>()
  factory AudioFastForwardButtonState.enabled() = _AudioFastForwardButtonStateEnabled;
}
