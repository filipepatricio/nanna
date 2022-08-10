import 'dart:async';

import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/past_days_brief_dto.dt.dart';

abstract class DailyBriefApiDataSource {
  Future<BriefDTO> currentBrief();

  Future<List<PastDaysBriefDTO>> pastDaysBriefs();

  Stream<BriefDTO?> currentBriefStream();
}
