import 'package:better_informed_mobile/domain/daily_brief/data/brief_calendar.dt.dart';

abstract class DailyBriefCalendarLocalRepository {
  Future<void> save(BriefCalendar calendar);

  Future<BriefCalendar?> load();

  Future<void> clear();
}
