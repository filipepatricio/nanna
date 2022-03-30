import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_state.freezed.dart';

@freezed
class AudioPlaybackState with _$AudioPlaybackState {
  const factory AudioPlaybackState.notInitialized() = _AudioPlaybackStateNotInitialized;

  const factory AudioPlaybackState.loading() = _AudioPlaybackStateLoading;

  const factory AudioPlaybackState.playing(
    Duration duration,
  ) = _AudioPlaybackStatePlaying;

  const factory AudioPlaybackState.paused(
    Duration duration,
  ) = _AudioPlaybackStatePaused;

  const factory AudioPlaybackState.completed(
    Duration duration,
  ) = _AudioPlaybackStateCompleted;
}
