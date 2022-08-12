import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';

abstract class DailyBriefRepository {
  Future<Brief> getCurrentBrief();

  Future<List<PastDaysBrief>> getPastDaysBriefs();

  Stream<Brief> currentBriefStream();
}
