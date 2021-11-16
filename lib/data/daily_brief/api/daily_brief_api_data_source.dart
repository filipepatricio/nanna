import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dart';

abstract class DailyBriefApiDataSource {
  Future<CurrentBriefDTO> currentBrief();

  Future<String> currentBriefId();
}
