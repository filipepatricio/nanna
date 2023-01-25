import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:hive/hive.dart';

part 'bookmark_data_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.bookmarkDataEntity)
class BookmarkDataEntity {
  BookmarkDataEntity({
    ArticleHeaderEntity? article,
    TopicEntity? topic,
  })  : _article = article,
        _topic = topic;

  BookmarkDataEntity.article(ArticleHeaderEntity article) : this(article: article);

  BookmarkDataEntity.topic(TopicEntity topic) : this(topic: topic);

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
