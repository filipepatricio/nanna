import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_media_item_mapper.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_playback_state_mapper.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioRepository, env: liveEnvs)
class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(
    this._audioHandler,
    this._audioPlaybackStateMapper,
    this._audioMediaItemMapper,
  );

  final AudioHandler _audioHandler;
  final AudioPlaybackStateMapper _audioPlaybackStateMapper;
  final AudioMediaItemMapper _audioMediaItemMapper;

  @override
  Future<void> closeItem() async {
    await _audioHandler.stop();
  }

  @override
  Future<void> prepareItem(AudioItem item) async {
    final mediaItem = _audioMediaItemMapper(item);
    await _audioHandler.playMediaItem(mediaItem);
  }

  @override
  Future<void> pause() async {
    await _audioHandler.pause();
  }

  @override
  Future<void> play() async {
    await _audioHandler.play();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioHandler.seek(position);
  }

  @override
  Stream<AudioPlaybackState> get playbackState {
    return _audioHandler.playbackState.map(_audioPlaybackStateMapper);
  }

  @override
  Stream<Duration> get position => AudioService.position;

  @override
  Future<void> fastForward() async {
    await _audioHandler.fastForward();
  }

  @override
  Future<void> rewind() async {
    await _audioHandler.rewind();
  }
}
