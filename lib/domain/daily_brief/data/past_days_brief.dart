import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';

class PastDaysBrief {
  PastDaysBrief({
    required this.brief,
    required this.date,
  });

  final CurrentBrief? brief;
  final DateTime date;

  @override
  String toString() => 'PastDaysBrief(brief: $brief, briefDate: $date)';
}
