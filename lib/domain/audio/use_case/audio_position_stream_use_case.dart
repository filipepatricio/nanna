import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AudioPositionStreamUseCase {
  AudioPositionStreamUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Stream<AudioPosition> call() {
    return Rx.combineLatest2<Duration, AudioPlaybackState, AudioPosition>(
      _audioRepository.position,
      _audioRepository.playbackState,
      (position, playbackState) => AudioPosition(
        position: position,
        totalDuration: playbackState.duration,
      ),
    );
  }
}
