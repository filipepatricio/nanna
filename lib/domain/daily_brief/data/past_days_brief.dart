import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';

class PastDaysBrief {
  const PastDaysBrief({
    required this.brief,
    required this.date,
  });

  final Brief? brief;
  final DateTime date;

  @override
  String toString() => 'PastDaysBrief(brief: $brief, briefDate: $date)';
}
