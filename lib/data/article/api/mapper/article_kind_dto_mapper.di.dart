import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_kind.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleKindDTOMapper implements Mapper<ArticleKindDTO, ArticleKind> {
  ArticleKindDTOMapper();

  @override
  ArticleKind call(ArticleKindDTO data) {
    return ArticleKind(
      name: data.name,
    );
  }
}
