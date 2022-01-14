import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/current_brief_dto_mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@LazySingleton(as: DailyBriefRepository)
class DailyBriefRepositoryImpl implements DailyBriefRepository {
  final DailyBriefApiDataSource _dailyBriefApiDataSource;
  final CurrentBriefDTOMapper _currentBriefDTOMapper;

  final BehaviorSubject<CurrentBrief> _currentBriefStream = BehaviorSubject();

  DailyBriefRepositoryImpl(
    this._dailyBriefApiDataSource,
    this._currentBriefDTOMapper,
  );

  @override
  Future<CurrentBrief> getCurrentBrief() async {
    final dto = await _dailyBriefApiDataSource.currentBrief();
    final currentBrief = _currentBriefDTOMapper(dto);

    _currentBriefStream.add(currentBrief);

    return currentBrief;
  }

  @override
  Stream<CurrentBrief> currentBriefStream() => _currentBriefStream.stream;
}
