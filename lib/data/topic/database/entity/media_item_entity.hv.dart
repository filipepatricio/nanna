import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'media_item_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.mediaItemEntity)
class MediaItemEntity {
  MediaItemEntity(this._article);

  MediaItemEntity.article(this._article);

  @HiveField(0)
  final ArticleHeaderEntity? _article;

  T map<T>({
    required T Function(ArticleHeaderEntity article) article,
  }) {
    if (_article != null) {
      return article(_article!);
    }
    throw Exception('Invalid MediaItemEntity');
  }
}
