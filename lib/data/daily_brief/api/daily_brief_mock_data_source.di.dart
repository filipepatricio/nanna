import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/briefs_wrapper_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefApiDataSource, env: mockEnvs)
class DailyBriefMockDataSource implements DailyBriefApiDataSource {
  @override
  Future<BriefsWrapperDTO> currentBrief() async {
    return BriefsWrapperDTO(
      MockDTO.currentBrief(),
      MockDTO.pastDaysBriefs,
    );
  }

  @override
  Stream<BriefsWrapperDTO?> currentBriefStream() async* {
    yield BriefsWrapperDTO(
      MockDTO.currentBrief(),
      MockDTO.pastDaysBriefs,
    );
  }

  @override
  Future<BriefDTO> pastBrief(DateTime dateTime) async {
    return MockDTO.currentBrief(date: dateTime);
  }
}
