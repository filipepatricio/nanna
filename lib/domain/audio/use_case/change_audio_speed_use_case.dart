import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeAudioSpeedUseCase {
  ChangeAudioSpeedUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Future<void> call(double speed) async => _audioRepository.changeAudioSpeed(speed);
}
