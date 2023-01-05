import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/handler/current_audio_item_dto.dt.dart';
import 'package:better_informed_mobile/data/audio/handler/informed_base_audio_handler.dart';
import 'package:better_informed_mobile/data/audio/handler/playback_state_extension.dart';
import 'package:better_informed_mobile/domain/audio/exception/audio_file_loading_exception.dart';
import 'package:better_informed_mobile/domain/audio/exception/unknown_audio_file_duration_exception.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class InformedAudioHandler extends InformedBaseAudioHandler with SeekHandler {
  InformedAudioHandler(this._audioPlayer);

  final AudioPlayer _audioPlayer;
  // Ignoring warning required by AudioHandler
  // ignore: close_sinks
  final BehaviorSubject<CurrentAudioItemDTO> _currentAudioItemSubject = BehaviorSubject();

  StreamSubscription? _audioEventSubscription;

  @override
  Future<void> initialize() async {
    Rx.combineLatest2<PlaybackState, MediaItem?, CurrentAudioItemDTO>(
      playbackState,
      mediaItem,
      (playbackState, mediaItme) => CurrentAudioItemDTO(
        state: playbackState,
        mediaItem: mediaItme,
      ),
    ).listen(_currentAudioItemSubject.add);
  }

  @override
  Future<void> notifyLoading(MediaItem item) async {
    await _audioPlayer.pause();
    await _audioPlayer.setSpeed(1.0);

    mediaItem.add(item);
    playbackState.add(PlaybackStateExtension.getLoading());
  }

  @override
  Future<Duration> open(String path) async {
    try {
      final duration = await _audioPlayer.setFilePath(path);
      if (duration == null) throw AudioFileUnknownDurationException(path);

      await _registerPlaybackEventListener();

      mediaItem.add(mediaItem.value?.copyWith(duration: duration));
      playbackState.add(PlaybackStateExtension.getLoaded(duration));

      return duration;
    } on PlayerInterruptedException catch (e) {
      throw AudioFileLoadingException(path, e.message);
    }
  }

  @override
  Future<void> play() async {
    if (playbackState.value.processingState == AudioProcessingState.completed) {
      await _setupPlayFromBeginning();
    }

    unawaited(_audioPlayer.play());

    final state = playbackState.value.getPlaying();
    playbackState.add(state);
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();

    final event = _audioPlayer.playbackEvent;
    final state = playbackState.value.getPaused(event.updatePosition);
    playbackState.add(state);
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);

    final isComplete = _audioPlayer.duration == position;

    final state = playbackState.value.copyWith(
      updatePosition: position,
      processingState: isComplete ? AudioProcessingState.completed : AudioProcessingState.ready,
    );
    playbackState.add(state);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);

    final event = _audioPlayer.playbackEvent;
    final newState = playbackState.value.copyWith(
      speed: speed,
      updatePosition: event.updatePosition,
    );
    playbackState.add(newState);
  }

  Future<void> _registerPlaybackEventListener() async {
    await _audioEventSubscription?.cancel();
    _audioEventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        final newState = playbackState.value.getCompleted(event.updatePosition);
        playbackState.add(newState);
      }
    });
  }

  Future<void> _setupPlayFromBeginning() async {
    await _audioPlayer.seek(Duration.zero);
    playbackState.add(
      playbackState.value.copyWith(
        updatePosition: Duration.zero,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> stop() async {
    playbackState.add(PlaybackStateExtension.getClosed());
    mediaItem.add(null);

    await _audioEventSubscription?.cancel();
    await _audioPlayer.stop();

    return super.stop();
  }

  @override
  Stream<CurrentAudioItemDTO> get currentAudioItemStream => _currentAudioItemSubject;
}
