import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_category.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';

class Topic {
  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final TopicOwner owner;
  final List<TopicSummary> topicSummaryList;
  final DateTime lastUpdatedAt;
  final List<Publisher> highlightedPublishers;
  final TopicCategory? category;
  final Image heroImage;
  final Image coverImage;
  final ReadingList readingList;

  Topic({
    required this.id,
    required this.slug,
    required this.title,
    required this.strippedTitle,
    required this.introduction,
    required this.url,
    required this.owner,
    required this.lastUpdatedAt,
    required this.topicSummaryList,
    required this.highlightedPublishers,
    required this.heroImage,
    required this.coverImage,
    required this.readingList,
    this.category,
  });

  MediaItemArticle articleAt(int index) => readingList.entries[index].item as MediaItemArticle;
}
