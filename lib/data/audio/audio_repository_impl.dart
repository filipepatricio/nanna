import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/audio_file_downloader.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_playback_state_mapper.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: AudioRepository, env: liveEnvs)
class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(
    this._audioHandler,
    this._audioPlaybackStateMapper,
    this._audioFileDownloader,
  );

  final AudioHandler _audioHandler;
  final AudioPlaybackStateMapper _audioPlaybackStateMapper;
  final AudioFileDownloader _audioFileDownloader;

  @override
  Future<void> closeItem() async {
    await _audioHandler.stop();
  }

  @override
  Future<void> prepareItem(AudioItem item) async {
    await _audioHandler.prepare();

    final fileName = _getAudioFileName(item);
    final audioFile = await _getAudioFile(fileName);
    await _audioFileDownloader.loadAndSaveFile(audioFile, item.fileUrl);

    final imageUrl = item.imageUrl;
    final mediaItem = MediaItem(
      id: audioFile.path,
      title: item.title,
      artist: item.author,
      artUri: imageUrl == null ? null : Uri.parse(imageUrl),
    );

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

  @override
  Future<void> changeAudioSpeed(double speed) async {
    await _audioHandler.setSpeed(speed);
  }

  Future<File> _getAudioFile(String fileName) async {
    final tmpDir = await getTemporaryDirectory();
    final filePath = join(tmpDir.path, fileName);
    return File(filePath);
  }

  String _getAudioFileName(AudioItem audioItem) {
    final uri = Uri.parse(audioItem.fileUrl);
    final lastSegment = uri.pathSegments.last;
    return lastSegment;
  }
}
