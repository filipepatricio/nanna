import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/past_days_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: mockEnvs)
class DailyBriefMockDataSource implements DailyBriefApiDataSource {
  @override
  Future<BriefDTO> currentBrief() async {
    return MockDTO.currentBrief();
  }

  @override
  Stream<BriefDTO?> currentBriefStream() async* {
    yield MockDTO.currentBrief();
  }

  @override
  Future<List<PastDaysBriefDTO>> pastDaysBriefs() async {
    return MockDTO.pastDaysBriefs;
  }
}
