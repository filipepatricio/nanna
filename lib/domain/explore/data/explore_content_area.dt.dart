import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_area.dt.freezed.dart';

@Freezed(toJson: false)
class ExploreContentArea with _$ExploreContentArea {
  factory ExploreContentArea.articles({
    required String id,
    required String title,
    required String? description,
    required String? icon,
    required bool isHighlighted,
    required bool isPreferred,
    required List<MediaItemArticle> articles,
  }) = ExploreContentAreaArticles;

  factory ExploreContentArea.articlesList({
    required String id,
    required String title,
    required String? description,
    required String? icon,
    required bool isHighlighted,
    required bool isPreferred,
    required List<MediaItemArticle> articles,
  }) = ExploreContentAreaArticlesList;

  factory ExploreContentArea.smallTopics({
    required String id,
    required String title,
    required String? description,
    required String? icon,
    required bool isHighlighted,
    required bool isPreferred,
    required List<TopicPreview> topics,
  }) = ExploreContentAreaSmallTopics;

  factory ExploreContentArea.unknown({
    required String id,
  }) = ExploreContentAreaUnknown;
}
