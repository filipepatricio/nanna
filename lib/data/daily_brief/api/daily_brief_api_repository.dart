import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/current_brief_dto_mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DailyBriefRepository)
class DailyBriefApiRepository implements DailyBriefRepository {
  final DailyBriefApiDataSource _dailyBriefApiDataSource;
  final CurrentBriefDTOMapper _currentBriefDTOMapper;

  DailyBriefApiRepository(
    this._dailyBriefApiDataSource,
    this._currentBriefDTOMapper,
  );

  @override
  Future<CurrentBrief> getCurrentBrief() async {
    final dto = await _dailyBriefApiDataSource.currentBrief();
    return _currentBriefDTOMapper(dto);
  }

  @override
  Future<String> getCurrentBriefId() {
    return _dailyBriefApiDataSource.currentBriefId();
  }
}
