import 'package:better_informed_mobile/data/article/api/dto/article_type_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleTypeDTOMapper implements Mapper<ArticleTypeDTO, ArticleType> {
  @override
  ArticleType call(ArticleTypeDTO data) {
    switch (data) {
      case ArticleTypeDTO.free:
        return ArticleType.free;
      case ArticleTypeDTO.premium:
        return ArticleType.premium;
      default:
        throw Exception('Unknown article type: $data');
    }
  }
}
