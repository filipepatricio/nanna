import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_category.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';

class Topic {
  final String id;
  final String title;
  final String introduction;
  final List<TopicSummary> summary;
  final List<Publisher>? highlightedPublisherList;
  final TopicCategory category;
  final Image heroImage;
  final Image coverImage;
  final ReadingList readingList;

  Topic({
    required this.id,
    required this.title,
    required this.introduction,
    required this.summary,
    required this.highlightedPublisherList,
    required this.category,
    required this.heroImage,
    required this.coverImage,
    required this.readingList,
  });
}
