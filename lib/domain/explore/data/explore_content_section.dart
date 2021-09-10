import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_section.freezed.dart';

@freezed
class ExploreContentSection with _$ExploreContentSection {
  factory ExploreContentSection.articles({
    required String title,
    required int themeColor,
    required List<ArticleHeader> articles,
  }) = ExploreContentSectionArticles;

  factory ExploreContentSection.readingLists({
    required String title,
    required List<Topic> topics,
  }) = ExploreContentSectionReadingLists;
}
