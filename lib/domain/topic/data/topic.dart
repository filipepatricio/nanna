import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_category.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:easy_localization/easy_localization.dart';

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

  String _daysCount(int howMany) => Intl.plural(
    howMany,
    one: 'Updated $howMany day ago',
    other: 'Updated $howMany days ago',
    name: 'day',
    args: [howMany],
    examples: const {'howMany': 42},
    desc: 'How many days since updated',
  );

  String _hoursCount(int howMany) => Intl.plural(
    howMany,
    one: 'Updated $howMany hour ago',
    other: 'Updated $howMany hours ago',
    name: 'hour',
    args: [howMany],
    examples: const {'howMany': 42},
    desc: 'How many hour since updated',
  );

  String lastUpdatedAtLabel() {
    final daysBetweenLastUpdatedDate = DateFormatUtil.daysBetween(lastUpdatedAt, DateTime.now());
    final hoursBetweenLastUpdatedDate = DateFormatUtil.hoursBetween(lastUpdatedAt, DateTime.now());
    return daysBetweenLastUpdatedDate > 0 ? _daysCount(daysBetweenLastUpdatedDate) : _hoursCount(hoursBetweenLastUpdatedDate);
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
