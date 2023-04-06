import 'package:audio_service/audio_service.dart';

extension PlaybackStateExtension on PlaybackState {
  static PlaybackState getClosed() => PlaybackState(
        playing: false,
        processingState: AudioProcessingState.idle,
      );

  static PlaybackState getLoading(double speed) => PlaybackState(
        playing: false,
        speed: speed,
        processingState: AudioProcessingState.loading,
      );

  static PlaybackState getLoaded(Duration duration, double speed) => PlaybackState(
        playing: false,
        speed: speed,
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
