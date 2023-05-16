import 'dart:async';

import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/briefs_wrapper_dto.dt.dart';

abstract class DailyBriefApiDataSource {
  Future<BriefsWrapperDTO> currentBrief();

  Future<BriefsWrapperDTO> currentBriefGuest();

  Future<BriefDTO> pastBrief(DateTime dateTime);

  Stream<BriefsWrapperDTO?> currentBriefStream();

  void dispose();
}
