import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';

class Brief {
  const Brief({
    required this.id,
    required this.unseenCount,
    required this.greeting,
    required this.introduction,
    required this.date,
    required this.sections,
    required this.relax,
  });

  final String id;
  final int unseenCount;
  final Headline greeting;
  final BriefIntroduction? introduction;
  final DateTime date;
  final List<BriefSection> sections;
  final Relax relax;

  List<BriefEntry> get allEntries => sections
      .expand<BriefEntry>(
        (section) => section.map(
          entries: (section) => section.entries,
          subsections: (section) => section.subsections.expand(
            (subsection) => subsection.entries,
          ),
          unknown: (_) => [],
        ),
      )
      .whereType<BriefEntry>()
      .toList();
}
