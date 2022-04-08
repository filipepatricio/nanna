import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AudioPositionStreamUseCase {
  AudioPositionStreamUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Stream<AudioPosition> call() {
    return Rx.combineLatest2<Duration, AudioPlaybackState, AudioPosition>(
      _audioRepository.position.startWith(Duration.zero),
      _audioRepository.playbackState.where((state) => state.hasDuration),
      (position, playbackState) => AudioPosition(
        audioItemID: playbackState.requireAudioItem.id,
        position: position,
        totalDuration: playbackState.requireDuration,
      ),
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

  Duration get requireDuration {
    return maybeMap(
      playing: (state) => state.duration,
      paused: (state) => state.duration,
      completed: (state) => state.duration,
      orElse: () => throw Exception('This state does not have duration'),
    );
  }

  AudioItem get requireAudioItem {
    return maybeMap(
      playing: (state) => state.audioItem,
      paused: (state) => state.audioItem,
      completed: (state) => state.audioItem,
      orElse: () => throw Exception('This state does not have audio item'),
    );
  }
}
