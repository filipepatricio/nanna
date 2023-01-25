import 'package:better_informed_mobile/data/article/database/entity/article_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_audio_file_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_content_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_header_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleEntityMapper extends BidirectionalMapper<ArticleEntity, Article> {
  ArticleEntityMapper(
    this._articleHeaderEntityMapper,
    this._articleContentEntityMapper,
    this._articleAudioFileEntityMapper,
  );

  final ArticleHeaderEntityMapper _articleHeaderEntityMapper;
  final ArticleContentEntityMapper _articleContentEntityMapper;
  final ArticleAudioFileEntityMapper _articleAudioFileEntityMapper;

  @override
  ArticleEntity from(Article data) {
    final audioFile = data.audioFile;

    return ArticleEntity(
      header: _articleHeaderEntityMapper.from(data.metadata),
      content: _articleContentEntityMapper.from(data.content),
      audioFile: audioFile != null ? _articleAudioFileEntityMapper.from(audioFile) : null,
    );
  }

  @override
  Article to(ArticleEntity data) {
    final audioFile = data.audioFile;

    return Article(
      metadata: _articleHeaderEntityMapper.to(data.header),
      content: _articleContentEntityMapper.to(data.content),
      audioFile: audioFile != null ? _articleAudioFileEntityMapper.to(audioFile) : null,
    );
  }
}
