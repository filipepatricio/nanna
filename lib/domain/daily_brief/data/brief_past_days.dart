import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';

class BriefPastDays {
  const BriefPastDays(this.days);

  factory BriefPastDays.empty() => const BriefPastDays([]);

  final List<BriefPastDay> days;
}
