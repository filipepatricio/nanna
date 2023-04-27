import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:clock/clock.dart';

class BriefPastDays {
  const BriefPastDays(this.days);

  factory BriefPastDays.empty() => BriefPastDays(emptyDays());

  final List<BriefPastDay> days;
}

List<BriefPastDay> emptyDays([DateTime? startDate, int? daysCount]) {
  final now = clock.now();
  final start = startDate ?? now;
  final count = daysCount ?? 7;

  return List.generate(
    count,
    (index) => BriefPastDay.empty(start.subtract(Duration(days: index))),
  );
}
