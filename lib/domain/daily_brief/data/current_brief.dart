import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';

class CurrentBrief {
  CurrentBrief({
    required this.id,
    required this.greeting,
    required this.introduction,
    required this.goodbye,
    required this.date,
    required this.entries,
  });
  final String id;
  final Headline greeting;
  final CurrentBriefIntroduction? introduction;
  final Headline goodbye;
  final DateTime date;
  final List<BriefEntry> entries;
}
