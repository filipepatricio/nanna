import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';

abstract class DailyBriefRepository {
  Future<CurrentBrief> getCurrentBrief();

  Future<List<PastDaysBrief>> getPastDaysBriefs();

  Stream<CurrentBrief> currentBriefStream();
}
