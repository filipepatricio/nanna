import 'dart:async';

import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/past_days_brief_dto.dt.dart';

abstract class DailyBriefApiDataSource {
  Future<CurrentBriefDTO> currentBrief();

  Future<List<PastDaysBriefDTO>> pastDaysBriefs();

  Stream<CurrentBriefDTO?> currentBriefStream();
}
