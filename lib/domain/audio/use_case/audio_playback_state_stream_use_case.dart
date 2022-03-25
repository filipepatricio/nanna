import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPlaybackStateStreamUseCase {
  AudioPlaybackStateStreamUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Stream<AudioPlaybackState> call() => _audioRepository.playbackState;
}
