import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_item.dt.freezed.dart';

@Freezed(toJson: false)
class CategoryItem with _$CategoryItem {
  factory CategoryItem.article(MediaItemArticle article) = _CategoryItemArticle;

  factory CategoryItem.topic(TopicPreview topicPreview) = _CategoryItemTopic;

  factory CategoryItem.unknown() = _CategoryItemUnknown;
}

extension CategoryItemExtension on CategoryItem {
  String get typeName => maybeMap(
        article: (_) => 'article',
        topic: (_) => 'topic',
        orElse: () => 'unknown',
      );

  String get typeId => map(
        article: (item) => item.article.id,
        topic: (topic) => topic.topicPreview.id,
        unknown: (_) => 'unknown',
      );
}
