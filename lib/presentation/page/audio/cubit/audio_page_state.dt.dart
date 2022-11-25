import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class AudioPageState with _$AudioPageState {
  @Implements<BuildState>()
  factory AudioPageState.notInitialized() = _AudioPageStateNotInitialized;

  @Implements<BuildState>()
  factory AudioPageState.initializing() = _AudioPageStateInitializing;

  @Implements<BuildState>()
  factory AudioPageState.initialized() = _AudioPageStateInitialized;
}
