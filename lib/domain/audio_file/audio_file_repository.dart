import 'package:better_informed_mobile/domain/audio_file/data/audio_file.dart';

abstract class AudioFileRepository {
  Future<AudioFile> getArticleAudioFile(String slug);
}
