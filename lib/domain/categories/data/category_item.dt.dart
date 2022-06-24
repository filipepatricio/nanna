import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_item.dt.freezed.dart';

@freezed
class CategoryItem with _$CategoryItem {
  factory CategoryItem.article(MediaItemArticle article) = _CategoryItemArticle;

  factory CategoryItem.topic(TopicPreview topicPreview) = _CategoryItemTopic;

  factory CategoryItem.unknown() = _CategoryItemUnknown;
}
