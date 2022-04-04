import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FastForwardAudioUseCase {
  FastForwardAudioUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Future<void> call() => _audioRepository.fastForward();
}
