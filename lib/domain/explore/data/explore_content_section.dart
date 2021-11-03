import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_section.freezed.dart';

@freezed
class ExploreContentSection with _$ExploreContentSection {
  factory ExploreContentSection.articles({
    required String title,
    required List<MediaItemArticle> articles,
  }) = ExploreContentSectionArticles;

  factory ExploreContentSection.articleWithFeature({
    required String title,
    required int backgroundColor,
    required MediaItemArticle featuredArticle,
    required List<MediaItemArticle> articles,
  }) = ExploreContentSectionArticleWithFeature;

  factory ExploreContentSection.topics({
    required String title,
    required List<Topic> topics,
  }) = ExploreContentSectionTopics;
}
