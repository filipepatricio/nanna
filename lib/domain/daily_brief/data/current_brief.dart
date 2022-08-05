import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';

class CurrentBrief {
  CurrentBrief({
    required this.id,
    required this.greeting,
    required this.introduction,
    required this.date,
    required this.entries,
    required this.relax,
  });

  final String id;
  final Headline greeting;
  final CurrentBriefIntroduction? introduction;
  final DateTime date;
  final List<BriefEntry> entries;
  final Relax relax;
}
