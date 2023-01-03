import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentDTOMapper implements Mapper<ArticleContentDTO, ArticleContent> {
  ArticleContentDTOMapper(this._articleContentTypeDTOMapper);
  final ArticleContentTypeDTOMapper _articleContentTypeDTOMapper;

  @override
  ArticleContent call(ArticleContentDTO data) {
    return ArticleContent(
      type: _articleContentTypeDTOMapper(data.text.markupLanguage),
      content: data.text.content,
      credits: data.credits,
    );
  }
}
