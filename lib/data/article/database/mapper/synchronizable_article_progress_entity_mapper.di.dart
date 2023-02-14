import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/synchronizable_article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/article_progress_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableArticleProgressEntityMapper
    extends SynchronizableEntityMapper<ArticleProgressEntity, ArticleProgress> {
  SynchronizableArticleProgressEntityMapper(ArticleProgressEntityMapper mapper) : super(mapper);

  @override
  SynchronizableEntity<ArticleProgressEntity> createEntity({
    required ArticleProgressEntity? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableArticleProgressEntity(
      data: data,
      dataId: dataId,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
