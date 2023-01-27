import 'package:better_informed_mobile/data/article/database/entity/article_audio_file_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleAudioFileEntityMapper extends BidirectionalMapper<ArticleAudioFileEntity, AudioFile> {
  @override
  ArticleAudioFileEntity from(AudioFile data) {
    return ArticleAudioFileEntity(
      url: data.url,
      credits: data.credits,
    );
  }

  @override
  AudioFile to(ArticleAudioFileEntity data) {
    return AudioFile(
      url: data.url,
      credits: data.credits,
    );
  }
}
