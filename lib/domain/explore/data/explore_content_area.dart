import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_area.freezed.dart';

@freezed
class ExploreContentArea with _$ExploreContentArea {
  factory ExploreContentArea.articles({
    required String id,
    required String title,
    required List<MediaItemArticle> articles,
  }) = ExploreContentAreaArticles;

  factory ExploreContentArea.articleWithFeature({
    required String id,
    required String title,
    required int backgroundColor,
    required MediaItemArticle featuredArticle,
    required List<MediaItemArticle> articles,
  }) = ExploreContentAreaArticleWithFeature;

  factory ExploreContentArea.topics({
    required String id,
    required String title,
    required List<Topic> topics,
  }) = ExploreContentAreaTopics;

  factory ExploreContentArea.unknown({
    required String id,
  }) = ExploreContentAreaUnknown;
}
