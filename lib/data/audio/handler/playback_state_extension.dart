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
          MediaControl.rewind,
          MediaControl.play,
          MediaControl.fastForward,
        ],
        bufferedPosition: duration,
      );

  PlaybackState getPlaying() => copyWith(
        playing: true,
        controls: [
          MediaControl.rewind,
          MediaControl.pause,
          MediaControl.fastForward,
        ],
      );

  PlaybackState getPaused(Duration updatePosition) => copyWith(
        playing: false,
        controls: [
          MediaControl.rewind,
          MediaControl.play,
          MediaControl.fastForward,
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
