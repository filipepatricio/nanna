import 'package:better_informed_mobile/domain/audio/audio_progress_tracker.di.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AudioPositionStreamUseCase {
  AudioPositionStreamUseCase(
    this._audioRepository,
    this._audioProgressTracker,
  );

  final AudioRepository _audioRepository;
  final AudioProgressTracker _audioProgressTracker;

  Stream<AudioPosition> call() {
    return Rx.combineLatest2<Duration, AudioPlaybackState, AudioPosition>(
      _audioRepository.position,
      _audioRepository.playbackState.where((state) => state.hasDuration),
      (position, playbackState) {
        _audioProgressTracker.track(
          playbackState.audioItem.id,
          position,
          playbackState.duration,
        );
        return AudioPosition(
          audioItemID: playbackState.audioItem.id,
          position: position,
          totalDuration: playbackState.duration,
        );
      },
    );
  }
}

extension on AudioPlaybackState {
  bool get hasDuration {
    return maybeMap(
      playing: (_) => true,
      paused: (_) => true,
      completed: (_) => true,
      orElse: () => false,
    );
  }

  Duration get duration {
    return maybeMap(
      playing: (state) => state.audioItem.duration ?? Duration.zero,
      paused: (state) => state.audioItem.duration ?? Duration.zero,
      completed: (state) => state.audioItem.duration ?? Duration.zero,
      orElse: () => throw Exception('This state does not have duration'),
    );
  }

  AudioItem get audioItem {
    return maybeMap(
      playing: (state) => state.audioItem,
      paused: (state) => state.audioItem,
      completed: (state) => state.audioItem,
      orElse: () => throw Exception('This state does not have audio item'),
    );
  }
}
