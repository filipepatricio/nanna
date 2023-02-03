import 'package:better_informed_mobile/data/article/database/entity/article_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/synchronizable_article_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableArticleEntityMapper extends SynchronizableEntityMapper<ArticleEntity, Article> {
  SynchronizableArticleEntityMapper(ArticleEntityMapper articleEntityMapper) : super(articleEntityMapper);

  @override
  SynchronizableEntity<ArticleEntity> createEntity({
    required ArticleEntity? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableArticleEntity(
      dataId: dataId,
      data: data,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
