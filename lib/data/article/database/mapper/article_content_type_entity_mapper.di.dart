import 'package:better_informed_mobile/data/article/database/entity/article_content_type_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:injectable/injectable.dart';

const _map = {
  ArticleContentType.html: 'html',
  ArticleContentType.markdown: 'markdown',
};

@injectable
class ArticleContentTypeEntityMapper extends BidirectionalMapper<ArticleContentTypeEntity, ArticleContentType> {
  @override
  ArticleContentTypeEntity from(ArticleContentType data) {
    return ArticleContentTypeEntity(
      name: _map[data.name]!,
    );
  }

  @override
  ArticleContentType to(ArticleContentTypeEntity data) {
    return _map.entries.firstWhere((element) => element.value == data.name).key;
  }
}
