import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_calendar_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_calendar.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefCalendarLocalRepository, env: mockEnvs)
class DailyBriefCalendarLocalRepositoryMock implements DailyBriefCalendarLocalRepository {
  @override
  Future<void> clear() async {}

  @override
  Future<BriefCalendar?> load() async {
    return null;
  }

  @override
  Future<void> save(BriefCalendar calendar) async {}
}
