import 'package:better_informed_mobile/data/article/api/dto/article_content_type_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentTypeDTOMapper implements Mapper<ArticleContentTypeDTO, ArticleContentType> {
  @override
  ArticleContentType call(ArticleContentTypeDTO data) {
    switch (data) {
      case ArticleContentTypeDTO.html:
        return ArticleContentType.html;
      case ArticleContentTypeDTO.markdown:
        return ArticleContentType.markdown;
    }
  }
}
