import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_section.freezed.dart';

@freezed
class ExploreContentSection with _$ExploreContentSection {
  factory ExploreContentSection.articles({
    required String title,
    required int themeColor,
    required List<Entry> entries,
  }) = ExploreContentSectionArticles;

  factory ExploreContentSection.articleWithCover({
    required String title,
    required int themeColor,
    required Entry coverEntry,
    required List<Entry> entries,
  }) = ExploreContentSectionArticleWithCover;

  factory ExploreContentSection.readingLists({
    required String title,
    required List<Topic> topics,
  }) = ExploreContentSectionReadingLists;
}
