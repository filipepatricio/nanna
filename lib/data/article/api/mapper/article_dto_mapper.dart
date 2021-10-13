import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_header_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleDTOMapper implements Mapper<ArticleDTO, Article> {
  final ArticleContentDTOMapper _articleContentDTOMapper;
  final ArticleHeaderDTOMapper _articleHeaderDTOMapper;

  ArticleDTOMapper(
    this._articleContentDTOMapper,
    this._articleHeaderDTOMapper,
  );

  @override
  Article call(ArticleDTO data) {
    final content = data.text;
    if (content == null) throw Exception('Content is missing');

    return Article(
      content: _articleContentDTOMapper(content),
      header: _articleHeaderDTOMapper(data),
    );
  }
}
