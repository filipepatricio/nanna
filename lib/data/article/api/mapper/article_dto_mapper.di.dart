import 'package:better_informed_mobile/data/article/api/dto/article_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_header_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/audio_file_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOMapper implements Mapper<ArticleDTO, Article> {
  ArticleDTOMapper(
    this._articleHeaderDTOMapper,
    this._articleContentDTOMapper,
    this._audioFileDTOMapper,
  );

  final ArticleHeaderDTOMapper _articleHeaderDTOMapper;
  final ArticleContentDTOMapper _articleContentDTOMapper;
  final AudioFileDTOMapper _audioFileDTOMapper;

  @override
  Article call(ArticleDTO data) {
    final audioFile = data.audioFile;

    return Article(
      metadata: _articleHeaderDTOMapper(data.header),
      content: _articleContentDTOMapper(data.content),
      audioFile: audioFile != null ? _audioFileDTOMapper(audioFile) : null,
    );
  }
}
