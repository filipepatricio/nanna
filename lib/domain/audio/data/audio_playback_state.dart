import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_state.freezed.dart';

@freezed
class AudioPlaybackState with _$AudioPlaybackState {
  const factory AudioPlaybackState.notInitialized() = _AudioPlaybackStateNotInitialized;

  const factory AudioPlaybackState.loading({
    required double speed,
  }) = _AudioPlaybackStateLoading;

  const factory AudioPlaybackState.playing({
    required Duration duration,
    required double speed,
  }) = _AudioPlaybackStatePlaying;

  const factory AudioPlaybackState.paused({
    required Duration duration,
    required double speed,
  }) = _AudioPlaybackStatePaused;

  const factory AudioPlaybackState.completed({
    required Duration duration,
    required double speed,
  }) = _AudioPlaybackStateCompleted;
}
