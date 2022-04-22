import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

class CurrentBrief {
  final String id;
  final Headline greeting;
  final Headline goodbye;
  final List<Topic> topics;
  final int numberOfTopics;

  CurrentBrief({
    required this.id,
    required this.greeting,
    required this.goodbye,
    required this.topics,
    required this.numberOfTopics,
  });
}
