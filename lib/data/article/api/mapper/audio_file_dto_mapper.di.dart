import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioFileDTOMapper implements Mapper<AudioFileDTO, AudioFile> {
  AudioFileDTOMapper();

  @override
  AudioFile call(AudioFileDTO data) {
    return AudioFile(
      url: data.url,
      credits: data.credits,
    );
  }
}
