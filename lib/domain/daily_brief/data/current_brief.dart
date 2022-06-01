import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

class CurrentBrief {
  final String id;
  final Headline greeting;
  final CurrentBriefIntroduction? introduction;
  final Headline goodbye;
  final List<Topic> topics;
  final int numberOfTopics;
  final DateTime date;
  final List<BriefEntry> entries;

  CurrentBrief({
    required this.id,
    required this.greeting,
    required this.introduction,
    required this.goodbye,
    required this.topics,
    required this.numberOfTopics,
    required this.date,
    required this.entries,
  });
}
