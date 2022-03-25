import 'package:audio_service/audio_service.dart';

extension PlaybackStateExtension on PlaybackState {
  static PlaybackState getLoading() => PlaybackState(
        playing: false,
        processingState: AudioProcessingState.loading,
      );

  static PlaybackState getLoaded(Duration duration) => PlaybackState(
        playing: false,
        processingState: AudioProcessingState.ready,
        controls: [
          MediaControl.play,
          MediaControl.fastForward,
          MediaControl.rewind,
        ],
        bufferedPosition: duration,
      );

  PlaybackState getPlaying() => copyWith(
        playing: true,
        controls: [
          MediaControl.pause,
          MediaControl.fastForward,
          MediaControl.rewind,
        ],
      );

  PlaybackState getPaused(Duration updatePosition) => copyWith(
        playing: false,
        controls: [
          MediaControl.play,
          MediaControl.fastForward,
          MediaControl.rewind,
        ],
        updatePosition: updatePosition,
      );

  PlaybackState getCompleted(Duration updatePosition) => copyWith(
        processingState: AudioProcessingState.completed,
        playing: false,
        controls: [
          MediaControl.play,
        ],
        updatePosition: updatePosition,
      );
}
