import 'package:better_informed_mobile/data/daily_brief/api/daily_brief_api_data_source.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/briefs_wrapper_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/briefs_wrapper_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: DailyBriefRepository)
class DailyBriefRepositoryImpl implements DailyBriefRepository {
  DailyBriefRepositoryImpl(
    this._dailyBriefApiDataSource,
    this._briefDTOMapper,
    this._briefsWrapperDTOMapper,
  );

  final DailyBriefApiDataSource _dailyBriefApiDataSource;
  final BriefDTOMapper _briefDTOMapper;
  final BriefsWrapperDTOMapper _briefsWrapperDTOMapper;

  final BehaviorSubject<BriefsWrapper> _currentBriefStream = BehaviorSubject();

  @override
  Future<BriefsWrapper> getCurrentBrief() async {
    final dto = await _dailyBriefApiDataSource.currentBrief();
    final currentBrief = _briefsWrapperDTOMapper(dto);

    _currentBriefStream.add(currentBrief);

    return currentBrief;
  }

  @override
  Future<BriefsWrapper> getCurrentBriefGuest() async {
    final dto = await _dailyBriefApiDataSource.currentBriefGuest();
    final currentBrief = _briefsWrapperDTOMapper(dto);
    return currentBrief;
  }

  @override
  Future<Brief> getPastBrief(DateTime date) async {
    final dto = await _dailyBriefApiDataSource.pastBrief(date);
    return _briefDTOMapper(dto);
  }

  @override
  Stream<BriefsWrapper> currentBriefStream() => _dailyBriefApiDataSource
      .currentBriefStream()
      .whereType<BriefsWrapperDTO>()
      .map((dto) => _briefsWrapperDTOMapper(dto));
}
