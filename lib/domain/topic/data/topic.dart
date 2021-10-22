import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_category.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jiffy/jiffy.dart';

class Topic {
  final String id;
  final String title;
  final String introduction;
  final DateTime lastUpdatedAt;
  final List<TopicSummary> summary;
  final List<Publisher> highlightedPublishers;
  final TopicCategory category;
  final Image heroImage;
  final Image coverImage;
  final ReadingList readingList;

  String lastUpdatedAtLabel() {
    final dateTest = DateTime.parse('2021-10-22T09:32:37Z').toLocal();
    return 'Updated ${Jiffy(dateTest).fromNow()}';
  }

  Topic({
    required this.id,
    required this.title,
    required this.introduction,
    required this.lastUpdatedAt,
    required this.summary,
    required this.highlightedPublishers,
    required this.category,
    required this.heroImage,
    required this.coverImage,
    required this.readingList,
  });
}
