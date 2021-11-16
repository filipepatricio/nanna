import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';

abstract class DailyBriefRepository {
  Future<CurrentBrief> getCurrentBrief();

  Future<String> getCurrentBriefId();
}
