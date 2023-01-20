import 'package:better_informed_mobile/data/article/database/entity/article_type_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:injectable/injectable.dart';

const _map = {
  ArticleType.free: 'free',
  ArticleType.premium: 'premium',
};

@injectable
class ArticleTypeEntityMapper extends BidirectionalMapper<ArticleTypeEntity, ArticleType> {
  @override
  ArticleTypeEntity from(ArticleType data) {
    return ArticleTypeEntity(name: _map[data]!);
  }

  @override
  ArticleType to(ArticleTypeEntity data) {
    return _map.entries.firstWhere((element) => element.value == data.name).key;
  }
}
