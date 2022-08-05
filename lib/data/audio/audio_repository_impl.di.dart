import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/audio_file_downloader.di.dart';
import 'package:better_informed_mobile/data/audio/handler/informed_base_audio_handler.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_playback_state_mapper.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: AudioRepository, env: liveEnvs)
class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(
    this._audioHandler,
    this._audioPlaybackStateMapper,
    this._audioItemMapper,
    this._audioFileDownloader,
  );

  final InformedBaseAudioHandler _audioHandler;
  final AudioPlaybackStateMapper _audioPlaybackStateMapper;
  final AudioItemMapper _audioItemMapper;
  final AudioFileDownloader _audioFileDownloader;

  final Map<String, Duration> _audioPositions = {};

  var _lastPosition = Duration.zero;
  var _totalDuration = Duration.zero;

  late MediaItemArticle _currentPlayedArticle;

  @override
  Future<void> closeItem() async {
    _setArticleAudioPosition(
      _currentPlayedArticle.slug,
      _lastPosition == _totalDuration ? Duration.zero : _lastPosition,
    );

    _lastPosition = Duration.zero;
    await _audioHandler.stop();
  }

  @override
  Future<void> prepareItem(AudioItem item, AudioFile audioFile, MediaItemArticle article) async {
    _currentPlayedArticle = article;

    final mediaItem = _audioItemMapper.from(item);
    await _audioHandler.notifyLoading(mediaItem);

    final fileName = _getAudioFileName(audioFile.url);
    final file = await _getAudioFile(fileName);
    await _audioFileDownloader.loadAndSaveFile(file, audioFile.url);

    _totalDuration = await _audioHandler.open(file.path);
  }

  @override
  Future<void> pause() async {
    _setArticleAudioPosition(_currentPlayedArticle.slug, _lastPosition);
    await _audioHandler.pause();
  }

  @override
  Future<void> play() async {
    await seek(_getArticleAudioPosition(_currentPlayedArticle));

    await _audioHandler.play();
  }

  @override
  Future<void> seek(Duration position) async {
    _setArticleAudioPosition(_currentPlayedArticle.slug, position);

    await _audioHandler.seek(position);
  }

  @override
  Stream<AudioPlaybackState> get playbackState {
    return _audioHandler.currentAudioItemStream.map(_audioPlaybackStateMapper);
  }

  @override
  Stream<Duration> get position async* {
    yield _lastPosition;
    await for (final position in AudioService.position) {
      _lastPosition = position;
      yield position;
    }
  }

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

  String _getAudioFileName(String url) {
    final uri = Uri.parse(url);
    final lastSegment = uri.pathSegments.last;
    return lastSegment;
  }

  Duration _getArticleAudioPosition(MediaItemArticle article) {
    if (_audioPositions[article.slug] == null) return Duration(seconds: article.progress.audioPosition);

    return _audioPositions[article.slug]!;
  }

  void _setArticleAudioPosition(String articleSlug, Duration position) {
    _audioPositions[articleSlug] = position;
  }
}
