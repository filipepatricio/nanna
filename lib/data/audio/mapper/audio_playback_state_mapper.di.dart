import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/handler/current_audio_item_dto.dt.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPlaybackStateMapper implements Mapper<CurrentAudioItemDTO, AudioPlaybackState> {
  AudioPlaybackStateMapper(this._audioItemMapper);

  final AudioItemMapper _audioItemMapper;

  @override
  AudioPlaybackState call(CurrentAudioItemDTO data) {
    final processingState = data.state.processingState;
    final mediaItem = data.mediaItem;

    if (mediaItem == null) {
      return const AudioPlaybackState.notInitialized();
    }

    switch (processingState) {
      case AudioProcessingState.idle:
        return const AudioPlaybackState.notInitialized();
      case AudioProcessingState.loading:
      case AudioProcessingState.buffering:
        return AudioPlaybackState.loading(
          speed: data.state.speed,
          audioItem: _audioItemMapper.to(mediaItem),
        );
      case AudioProcessingState.ready:
        return _mapReadyState(data.state, mediaItem);
      case AudioProcessingState.completed:
        return AudioPlaybackState.completed(
          speed: data.state.speed,
          audioItem: _audioItemMapper.to(mediaItem),
        );
      case AudioProcessingState.error:
        throw Exception('While playing audio some error occurred');
    }
  }

  AudioPlaybackState _mapReadyState(PlaybackState state, MediaItem mediaItem) {
    final duration = mediaItem.duration;

    if (duration == null) {
      return AudioPlaybackState.loading(
        speed: state.speed,
        audioItem: _audioItemMapper.to(mediaItem),
      );
    }

    if (state.playing) {
      return AudioPlaybackState.playing(
        speed: state.speed,
        audioItem: _audioItemMapper.to(mediaItem),
      );
    } else {
      return AudioPlaybackState.paused(
        speed: state.speed,
        audioItem: _audioItemMapper.to(mediaItem),
      );
    }
  }
}
