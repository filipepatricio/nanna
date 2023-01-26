import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:hive/hive.dart';

part 'bookmark_data_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.bookmarkDataEntity)
class BookmarkDataEntity {
  BookmarkDataEntity(this._article, this._topic);

  BookmarkDataEntity.article(this._article) : _topic = null;

  BookmarkDataEntity.topic(this._topic) : _article = null;

  @HiveField(0)
  final ArticleHeaderEntity? _article;
  @HiveField(1)
  final TopicEntity? _topic;

  T map<T>({
    required T Function(ArticleHeaderEntity article) article,
    required T Function(TopicEntity topic) topic,
  }) {
    if (_article != null) {
      return article(_article!);
    }
    if (_topic != null) {
      return topic(_topic!);
    }
    throw Exception('Invalid BookmarkDataEntity');
  }
}
