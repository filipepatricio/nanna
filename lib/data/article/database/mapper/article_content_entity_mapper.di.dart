import 'package:better_informed_mobile/data/article/database/entity/article_content_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_content_type_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentEntityMapper extends BidirectionalMapper<ArticleContentEntity, ArticleContent> {
  ArticleContentEntityMapper(this._articleContentTypeEntityMapper);

  final ArticleContentTypeEntityMapper _articleContentTypeEntityMapper;

  @override
  ArticleContentEntity from(ArticleContent data) {
    return ArticleContentEntity(
      type: _articleContentTypeEntityMapper.from(data.type),
      content: data.content,
      credits: data.credits,
    );
  }

  @override
  ArticleContent to(ArticleContentEntity data) {
    return ArticleContent(
      type: _articleContentTypeEntityMapper.to(data.type),
      content: data.content,
      credits: data.credits,
    );
  }
}
