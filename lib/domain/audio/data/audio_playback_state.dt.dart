import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_state.dt.freezed.dart';

@freezed
class AudioPlaybackState with _$AudioPlaybackState {
  const factory AudioPlaybackState.notInitialized() = _AudioPlaybackStateNotInitialized;

  const factory AudioPlaybackState.loading({
    required double speed,
    required AudioItem audioItem,
  }) = _AudioPlaybackStateLoading;

  const factory AudioPlaybackState.playing({
    required double speed,
    required AudioItem audioItem,
  }) = _AudioPlaybackStatePlaying;

  const factory AudioPlaybackState.paused({
    required double speed,
    required AudioItem audioItem,
  }) = _AudioPlaybackStatePaused;

  const factory AudioPlaybackState.completed({
    required double speed,
    required AudioItem audioItem,
  }) = _AudioPlaybackStateCompleted;
}
