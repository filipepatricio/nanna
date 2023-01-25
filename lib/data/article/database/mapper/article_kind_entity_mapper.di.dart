import 'package:better_informed_mobile/data/article/database/entity/article_kind_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_kind.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleKindEntityMapper extends BidirectionalMapper<ArticleKindEntity, ArticleKind> {
  @override
  ArticleKindEntity from(ArticleKind data) {
    return ArticleKindEntity(
      name: data.name,
    );
  }

  @override
  ArticleKind to(ArticleKindEntity data) {
    return ArticleKind(
      name: data.name,
    );
  }
}
