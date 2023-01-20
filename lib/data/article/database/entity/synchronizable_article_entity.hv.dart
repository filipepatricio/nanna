import 'package:better_informed_mobile/data/article/database/entity/article_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:hive/hive.dart';

part 'synchronizable_article_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.synchronizableArticleEntity)
class SynchronizableArticleEntity extends SynchronizableEntity<ArticleEntity> {
  SynchronizableArticleEntity({
    required super.data,
    required super.createdAt,
    required super.synchronizedAt,
    required super.expirationDate,
  });
}
