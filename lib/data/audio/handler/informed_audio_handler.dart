import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/handler/playback_state_extension.dart';
import 'package:just_audio/just_audio.dart';

class InformedAudioHandler extends BaseAudioHandler with SeekHandler {
  InformedAudioHandler(this._audioPlayer);

  final AudioPlayer _audioPlayer;

  StreamSubscription? _audioEventSubscription;

  @override
  Future<void> prepare() async {
    playbackState.add(PlaybackStateExtension.getLoading());
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    await _audioPlayer.pause();

    mediaItem.add(item);
    playbackState.add(PlaybackStateExtension.getLoading());

    final duration = await _audioPlayer.setFilePath(item.id);
    if (duration == null) throw Exception('Unknown audio file duration: ${item.id}');

    await _registerPlaybackEventListener();

    mediaItem.add(item.copyWith(duration: duration));
    playbackState.add(PlaybackStateExtension.getLoaded(duration));
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
    await _audioEventSubscription?.cancel();
    await _audioPlayer.stop();
    return super.stop();
  }
}
