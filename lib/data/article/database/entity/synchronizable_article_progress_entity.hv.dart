import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_article_progress_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableArticleProgressEntity)
class SynchronizableArticleProgressEntity extends SynchronizableEntity<ArticleProgressEntity> {
  SynchronizableArticleProgressEntity({
    required super.data,
    required super.dataId,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
