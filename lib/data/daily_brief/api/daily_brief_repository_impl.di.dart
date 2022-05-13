import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/current_brief_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: DailyBriefRepository)
class DailyBriefRepositoryImpl implements DailyBriefRepository {
  DailyBriefRepositoryImpl(
    this._dailyBriefApiDataSource,
    this._currentBriefDTOMapper,
  );

  final DailyBriefApiDataSource _dailyBriefApiDataSource;
  final CurrentBriefDTOMapper _currentBriefDTOMapper;

  final BehaviorSubject<CurrentBrief> _currentBriefStream = BehaviorSubject();

  @override
  Future<CurrentBrief> getCurrentBrief() async {
    final dto = await _dailyBriefApiDataSource.currentBrief();
    final currentBrief = _currentBriefDTOMapper(dto);

    _currentBriefStream.add(currentBrief);

    return currentBrief;
  }

  @override
  Stream<CurrentBrief> currentBriefStream() => _dailyBriefApiDataSource
      .currentBriefStream()
      .whereType<CurrentBriefDTO>()
      .map((dto) => _currentBriefDTOMapper(dto));
}
