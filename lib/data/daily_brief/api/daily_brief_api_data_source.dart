import 'dart:async';

import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';

abstract class DailyBriefApiDataSource {
  Future<CurrentBriefDTO> currentBrief();

  Stream<CurrentBriefDTO?> currentBriefStream();
}
