import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_type_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentDTOMapper implements Mapper<ArticleContentDTO, ArticleContent> {
  final ArticleContentTypeDTOMapper _articleContentTypeDTOMapper;

  ArticleContentDTOMapper(this._articleContentTypeDTOMapper);

  @override
  ArticleContent call(ArticleContentDTO data) {
    return ArticleContent(
      type: _articleContentTypeDTOMapper(data.markupLanguage),
      content: data.content,
    );
  }
}
