import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';

class BriefSubsection {
  const BriefSubsection({
    required this.title,
    required this.entries,
  });

  final String title;
  final List<BriefEntry> entries;

  BriefSubsection copyWith({
    String? title,
    List<BriefEntry>? entries,
  }) {
    return BriefSubsection(
      title: title ?? this.title,
      entries: entries ?? this.entries,
    );
  }
}
