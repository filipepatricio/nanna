import 'package:better_informed_mobile/data/audio_file/api/dto/audio_file_dto.dart';

abstract class AudioFileApiDataSource {
  Future<AudioFileDTO> getArticleAudioFile(String slug);
}
