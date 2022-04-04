import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPlaybackStateMapper implements Mapper<PlaybackState, AudioPlaybackState> {
  @override
  AudioPlaybackState call(PlaybackState data) {
    final processingState = data.processingState;
    final duration = data.bufferedPosition;

    switch (processingState) {
      case AudioProcessingState.idle:
        return const AudioPlaybackState.notInitialized();
      case AudioProcessingState.loading:
      case AudioProcessingState.buffering:
        return AudioPlaybackState.loading(
          speed: data.speed,
        );
      case AudioProcessingState.ready:
        return _mapReadyState(data);
      case AudioProcessingState.completed:
        return AudioPlaybackState.completed(
          duration: duration,
          speed: data.speed,
        );
      case AudioProcessingState.error:
        throw Exception('While playing audio some error occurred');
    }
  }

  AudioPlaybackState _mapReadyState(PlaybackState data) {
    final duration = data.bufferedPosition;

    if (data.playing) {
      return AudioPlaybackState.playing(
        duration: duration,
        speed: data.speed,
      );
    } else {
      return AudioPlaybackState.paused(
        duration: duration,
        speed: data.speed,
      );
    }
  }
}
