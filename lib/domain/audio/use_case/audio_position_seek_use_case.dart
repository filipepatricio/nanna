import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPositionSeekUseCase {
  AudioPositionSeekUseCase(this._audioRepository);

  final AudioRepository _audioRepository;

  Future<void> call(Duration position) async => _audioRepository.seek(position);
}
